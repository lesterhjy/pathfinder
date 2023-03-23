class EventsController < ApplicationController
  before_action :set_trip, only: [:new, :create, :edit, :update, :update_position]

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
      format.text { render partial: "recommendations/recommendation_list", locals: { recommendations: @recommendations }, formats: [:html] }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update_position
    @event = Event.find(params[:id])
    @events = @trip.events
    @events_that_day = @events.order(:position).select { |event| event.start_time.day == @event.start_time.day }
    old_index = @events_that_day.index(@event)
    old_position = @event.position
    new_index = event_params[:position].to_i - 1
    new_position = old_position + (new_index - old_index)
    @event.insert_at(new_position)
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
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
                                  :position)
  end

end
