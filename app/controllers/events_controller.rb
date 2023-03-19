class EventsController < ApplicationController
  before_action :set_trip, only: [:new, :create]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.trip = @trip
    if @event.save!
      redirect_to @trip
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def event_params
    params.require(:event).permit(:name, :address, :start_time, :end_time)
  end

end
