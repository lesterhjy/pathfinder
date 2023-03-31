class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  require "kmeans-clusterer"

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    @trip = Trip.find(params[:id])
    @event = Event.new
    # get events for different sources
    @recommendations = Event.where(trip: @trip, source: 'google', selected: nil)
    @self_created = Event.where(trip: @trip, source: 'self')
    # filtering all events associated with the trip
    @events = @trip.events.where(selected: true).order(:start_time, :position)
    if @events.empty?
      @events = @trip.events.order(:start_time, :position)
    end
    # geoclustering events
    @clusters = events_clustering(@events)
    # generating itinerary - flag is turned to "false" by default but will flip to "true" when event_generation is called once
    event_generation if @trip.generated != true

    @all_dates = (@trip.start_date.to_datetime..@trip.end_date.to_datetime).to_a
    @events_by_day = {}
    @all_dates.each do |date|
      events_that_day = @events.select { |e| e.start_time.day == date.day }
      @events_by_day[date.day] = events_that_day
    end
    # events for the first day - will show as default on the trip show page
    @first_day_events = @events_by_day[@all_dates.first.day]

    # when a tab is clicked, it will send a request to get the day's events
    if params[:day].present?
      @events = @events_by_day[params[:day].to_i]
    end

    respond_to do |format|
      format.html
      # this renders the tab info when you click on a specific day
      format.text { render partial: 'trips/events', locals: { events: @trip_events, trip: @trip }, formats: [:html] }
    end
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    # select the events selected by user
    @events = @trip.events.where(selected: true).order(:start_time, :position)
    if @events.empty?
      @events = @trip.events.order(:start_time, :position)
    end
    @all_dates = (@trip.start_date.to_datetime..@trip.end_date.to_datetime).to_a
    @events_by_day = {}
    @all_dates.each do |date|
      events_that_day = @events.select { |e| e.start_time.day == date.day }
      @events_by_day[date.day] = events_that_day
    end
    @highest_position = @events.last.position
  end

  private

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :latitude, :longitude)
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
end
