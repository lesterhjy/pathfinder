class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def show
    @events = @trip.events
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
