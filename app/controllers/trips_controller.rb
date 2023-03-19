class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def show
    @days = @trip.events.order(:start_time).group_by { |event| event.start_time.day }.values
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end


end
