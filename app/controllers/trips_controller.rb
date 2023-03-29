class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_trip, only: [:show]
  require "kmeans-clusterer"

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
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
      format.text { render partial: 'trips/events', locals: { events: @events, trip: @trip }, formats: [:html] }
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

  def set_trip
    @trip = Trip.find(params[:id])
  end

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
    k = 5 # Number of clusters
    kmeans = KMeansClusterer.run k, coords, labels: clustered_events, runs: 3
    clusters = []
    kmeans.clusters.each do |cluster|
      clusters.append(cluster.points.map(&:label))
    end
    clusters
  end

  def event_generation
    selected_events = @events.where(selected: true).pluck(:id)

    cluster_number = 0
    date = @trip.start_date.to_datetime
    while cluster_number < @clusters.length
      cluster = @clusters[cluster_number]
      if cluster.intersection(selected_events)
        clustered_selected_events = cluster.intersection(selected_events)
        clustered_selected_events.each do |event_id|
          event = Event.find(event_id)
          event.update(start_time: date)
        end
      end
      date += 1
      cluster_number += 1
    end

    @trip.update(generated: true)
  end
end
