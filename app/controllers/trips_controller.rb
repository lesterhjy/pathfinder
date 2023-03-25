class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    @events = @trip.events.order(:position).select { |event| event.selected == true }
    @first_day_events = @events.group_by { |event| event.start_time.day }.values[0]
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
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
