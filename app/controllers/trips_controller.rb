class TripsController < ApplicationController
  before_action :set_trip, only: [:show]
  require "kmeans-clusterer"

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    @events = @trip.events.order(:position)
    @clusters = events_clustering(@events)
    raise
    @first_day_events = @trip.events.order(:position).group_by { |event| event.start_time.day }.values[0]
    @events_by_day = @trip.events.order(:start_time, :position).group_by { |event| event.start_time.day }.values
    if params[:day].present?
      @events = @events.select { |event| event.start_time.day == params[:day].to_i }
    end

    respond_to do |format|
      format.html
      format.text { render partial: 'trips/events', locals: { events: @events }, formats: [:html] }
    end
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    @events_by_day = @trip.events.order(:start_time, :position).group_by { |event| event.start_time.day }.values
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
      clusters.append(cluster.points.map(&:label).join(", "))
    end
    clusters
  end

  def trip_creation(clusters)
    clusters.each do |cluster|
    end
  end
end
