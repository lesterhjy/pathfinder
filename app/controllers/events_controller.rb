class EventsController < ApplicationController
  before_action :set_trip, only: [:new, :create, :edit, :update]

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
      format.html
      format.text { render partial: "recommendations/recommendation_list", locals: { recommendations: @recommendations }, formats: [:html] }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to trip_path(@trip)
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
                                  :end_time)
  end

end
