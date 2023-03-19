class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def show
    @events = @trip.events.order(:start_time)
    @days = @trip.events.order(:start_time).group_by { |event| event.start_time.day }.values
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def filter_by_day
  end


end
