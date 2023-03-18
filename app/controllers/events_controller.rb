class EventsController < ApplicationController
  before_action :set_trip, only: [:new]

  def new
    @event = Event.new
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

end
