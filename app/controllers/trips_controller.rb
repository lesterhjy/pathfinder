class TripsController < ApplicationController
  require "kmeans-clusterer"

  def create
    @trip = Trip.new(trip_params)
    authorize @trip
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def index
    @trips = policy_scope(Trip)
  end

  def show
    @trip = Trip.find(params[:id])
    authorize @trip
    @flights = @trip.flights
    @hotels = @trip.hotels
    @event = Event.new
    @flight = Flight.new
    @hotel = Hotel.new
    # get events for different sources
    @recommendations = Event.where(trip: @trip, source: 'google', selected: nil, start_time: nil)
    @self_created = Event.where(trip: @trip, source: 'self', start_time: nil)
    # filtering all events associated with the trip
    @events = @trip.events
    # geoclustering events and populating trip
    unless @trip.skip == true || @trip.generated == true
      @clusters = events_clustering(@events)
      generate_event_start_time(event_generation)
    end
    # gathering the events for the show page
    @events = @events.where.not(start_time: nil).order(:start_time, :position)
    @all_dates = (@trip.start_date.to_date..@trip.end_date.to_date).to_a
    @events_by_day = {}
    @all_dates.each do |date|
      events_that_day = @events.select { |e| e.start_time.to_date == date }.sort_by { |e| e.position }
      @events_by_day[date] = events_that_day
    end

    @categories = search_categories

    # events for the first day - will show as default on the trip show page
    @first_day_events = @events_by_day.first[1]
    @first_day_date = @events_by_day.first[0]

    # when a tab is clicked, it will send a request to get the day's events
    if params[:date].present?
      @events = @events_by_day[params[:date].to_date]
      @date = params[:date].to_date
    end

    respond_to do |format|
      format.html
      # this renders the tab info when you click on a specific day
      format.text { render partial: 'trips/events', locals: { events: @events, date: @date, trip: @trip, flights: @flights, hotels: @hotels }, formats: [:html] }
    end
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    authorize @trip
    @flights = @trip.flights
    @hotels = @trip.hotels
    @user = @trip.users.first
    # select the events selected by user
    @events = @trip.events.where.not(start_time: nil).order(:start_time, :position)

    @all_dates = (@trip.start_date.to_date..@trip.end_date.to_date).to_a
    @events_by_day = {}
    @all_dates.each do |date|
      events_that_day = @events.select { |e| e.start_time.to_date == date }.sort_by { |e| e.position }
      @events_by_day[date] = events_that_day
    end
    if @events.last
      @highest_position = @events.last.position
    else
      @highest_position = 1
    end
    @categories = search_categories
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @trip.destination,
               template: "trips/trip",
               formats: [:html],
               disposition: :attachment,
               layout: 'pdf'
      end
    end
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.update(trip_params)
    redirect_to @trip
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to trips_path
  end

  private

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :latitude, :longitude, :skip)
  end

  def events_clustering(events)
    coords = []
    clustered_events = []
    events.each do |event|
      coords.append([event.latitude, event.longitude])
      clustered_events.append(event.id)
    end
    # k represents the number of clusters, and is based on the length of the trip
    k = (@trip.end_date.to_datetime.to_i - @trip.start_date.to_datetime.to_i + 86_400) / 86_400
    kmeans = KMeansClusterer.run k, coords, labels: clustered_events, runs: 3
    clusters = []
    kmeans.clusters.each do |cluster|
      clusters.append(cluster.points.map(&:label))
    end
    clusters
  end

  def event_generation
    @week_events = []
    selected_events = @events.where(selected: true).pluck(:id)
    unselected_events = @events.where(selected: nil).pluck(:id)
    cluster_number = 0
    while cluster_number < @clusters.length
      @day_events = []
      cluster = @clusters[cluster_number]
      if cluster.intersection(selected_events) # If user has selected any event belonging to the cluster.
        cluster.intersection(selected_events).each { |event_id| @day_events.append(event_id) if @day_events.length < 8 } # Inserting events selected by user first
      end
      cluster.intersection(unselected_events).each { |event_id| @day_events.append(event_id) if @day_events.length < 8 } # Filling up the gaps with events that were not selected.
      @week_events.append(@day_events) # Append the day's events to the week.
      cluster_number += 1
    end
    @trip.update(generated: true)
    @week_events
  end

  def generate_event_start_time(week_events)
    # Clearing dates for any stray events.
    @trip.events.each { |event| event.update(start_time: nil) }
    # Inserting dates for each day's events.
    date = @trip.start_date.to_datetime
    week_events.each do |day|
      day.each do |event_id|
        event = Event.find(event_id)
        event.update(start_time: date)
      end
      date += 1
    end
  end

  def search_categories
    { shopping: ["book_store",
                 "electronics_store",
                 "clothing_store",
                 "shoe_store",
                 "furniture_store",
                 "jewelry_store",
                 "department_store",
                 "shopping_mall"],
      attraction: ["casino",
                   "library",
                   "movie_theater",
                   "bowling_alley",
                   "amusement_park",
                   "museum",
                   "zoo",
                   "park",
                   "art_gallery",
                   "tourist_attraction"],
      food: ["bar",
             "cafe",
             "bakery",
             "restaurant",
             "night_club"] }
  end
end
