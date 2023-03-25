class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_trip, only: [:show]

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    # pick the trip's events, order by position, and select only those that the user has selected
    @events = @trip.events.order(:start_time, :position).select { |event| (event.selected == true) and event.start_time }
    # events for the first day - will show as default on the trip show page
    @first_day_events = @events.group_by { |event| event.start_time.day }.values[0]
    # all events - this is used for the tab info only for now
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
    # when a tab is clicked, it will send a request to get the day's events
    if params[:day].present?
      @events = @events.select { |event| event.start_time.day == params[:day].to_i }
    end

    respond_to do |format|
      format.html
      # this renders the tab info when you click on a specific day
      format.text { render partial: 'trips/events', locals: { events: @events }, formats: [:html] }
    end
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    # select the events selected by user
    @events = @trip.events.order(:position).select { |event| event.selected == true }
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :latitude, :longitude)
  end

end
