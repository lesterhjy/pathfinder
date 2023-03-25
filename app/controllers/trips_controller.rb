class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_trip, only: [:show]

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    @events = @trip.events.order(:position)
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

end
