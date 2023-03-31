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
    @events = @trip.events
    # geoclustering events
    @clusters = events_clustering(@events)
    # generating itinerary - flag is turned to "false" by default but will flip to "true" when event_generation is called once
    event_generation
    # events for the first day - will show as default on the trip show page
    @trip_events = @events.where.not(start_time: nil)
    @first_day_events = @trip_events.group_by { |event| event.start_time.day }.values[0]
    # all events - this is used for the tab info only for now
    @events_by_day = @trip_events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
    # when a tab is clicked, it will send a request to get the day's events
    if params[:day].present?
      @trip_events = @trip_events.select { |event| event.start_time.day == params[:day].to_i }
    end
    respond_to do |format|
      format.html
      # this renders the tab info when you click on a specific day
      format.text { render partial: 'trips/events', locals: { events: @trip_events, trip: @trip }, formats: [:html] }
    end
    # raise
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    # select the events selected by user
    @events = @trip.events.order(:position).select { |event| event.selected == true }
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
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
    all_events = @events.pluck(:id)
    selected_events = @events.where(selected: true).pluck(:id)
    unselected_events = @events.where(selected: nil).pluck(:id)

    @week_events = []

    cluster_number = 0
    date = @trip.start_date.to_datetime
    while cluster_number < @clusters.length
      @day_events = []
      cluster = @clusters[cluster_number]
      if cluster.intersection(selected_events)
        clustered_selected_events = cluster.intersection(selected_events)
        clustered_selected_events.each do |event_id|
          if @day_events.length < 8
            event = Event.find(event_id)
            event.update(start_time: date)
            @day_events.append(event_id)
            clustered_selected_events.delete(event)
          end
        end
        clustered_unselected_events = cluster.intersection(unselected_events)
        clustered_unselected_events.each do |event_id|
          if @day_events.length < 8
            event = Event.find(event_id)
            event.update(start_time: date)
            @day_events.append(event_id)
            clustered_unselected_events.delete(event)
          end
        end
        @week_events.append(@day_events)
      else
        clustered_unselected_events = cluster.intersection(unselected_events)
        clustered_unselected_events.each do |event_id|
          if @day_events.length < 8
            event = Event.find(event_id)
            event.update(start_time: date)
            @day_events.append(event_id)
            clustered_unselected_events.delete(event)
          end
        end
        @week_events.append(@day_events)
      end
      date += 1
      cluster_number += 1
    end

    @trip.update(generated: true)
  end
end
