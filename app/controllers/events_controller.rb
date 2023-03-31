class EventsController < ApplicationController
  before_action :set_trip, only: [:new, :create, :edit, :update, :destroy, :update_position, :move_lists]

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

  def update
    @recommendations = Event.where(trip_id: params[:id])
    @event = Event.find(params[:id])
    @event.update(event_params)
    respond_to do |format|
      format.html { redirect_to trip_path(@trip) }
      format.text { render partial: "trips/event_details", locals: { event: @event, trip: @trip }, formats: [:html] }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to @trip
  end

  def update_position
    @event = Event.find(params[:id])
    @events = @trip.events
    @events_that_day = @events.order(:position).select { |event| event.start_time.day == @event.start_time.day }
    old_index = @events_that_day.index(@event)
    old_position = @event.position
    new_index = event_params[:position].to_i - 1
    new_position = @events_that_day[new_index].position
    @event.insert_at(new_position)
  end

  def move_lists
    @event = Event.find(params[:id])
    @event.start_time = event_params[:start_time]
    @event.save
    @event.insert_at(event_params[:position].to_i)
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def move_params

  end

  def event_params
    params.require(:event).permit(:name,
                                  :source,
                                  :source_id,
                                  :lat,
                                  :lng,
                                  :address,
                                  :category,
                                  :website,
                                  :phone,
                                  :photo,
                                  :rating,
                                  :review,
                                  :description,
                                  :selected,
                                  :start_time,
                                  :end_time,
                                  :position,
                                  :note)
  end
end
