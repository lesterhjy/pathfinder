class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def show
    @events = @trip.events.order(:start_time)
    @days = @trip.events.order(:start_time).group_by { |event| event.start_time.day }.values
    if params[:day].present?
      @events = @events.select { |event| event.start_time.day == params[:day].to_i }
    end

    respond_to do |format|
      format.html
      format.text { render partial: 'trips/events', locals: { events: @events }, formats: [:html] }
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

end
