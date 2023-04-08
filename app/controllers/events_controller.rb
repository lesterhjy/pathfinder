class EventsController < ApplicationController
  before_action :set_trip, only: [:new, :create, :edit, :update, :destroy, :update_position, :move_lists]
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

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
    @categories = search_categories
    @recommendations = Event.where(trip_id: params[:id])
    @event = Event.find(params[:id])
    @event.update(event_params)
    respond_to do |format|
      format.html { redirect_to trip_path(@trip) }
      format.text { render partial: "trips/event_details", locals: { event: @event, trip: @trip, categories: @categories }, formats: [:html] }
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
    count = check_hotel(@event.start_time.to_date) + check_flight(@event.start_time.to_date)

    @events = @trip.events
    @events_that_day = @events.where.not(start_time: nil).select { |e| e.start_time.to_date == @event.start_time.to_date }.sort_by(&:position)
    new_index = event_params[:position].to_i - 1 - count
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

  def check_hotel(date)
    hotels = @trip.hotels
    count = 0
    hotels.each do |hotel|
      hotel_dates = (hotel.start_time.to_date..hotel.end_time.to_date).to_a
      count += 1 if hotel_dates.include? date
    end
    count
  end

  def check_flight(date)
    flights = @trip.flights
    count = 0
    flights.each do |flight|
      count += 1 if date == flight.start_time.to_date && date == @trip.start_date.to_date
    end
    count
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

  def search_categories
    { shopping: ["book_store",
                 "electronics_store",
                 "clothing_store",
                 "shoe_store",
                 "furniture_store",
                 "jewelry_store",
                 "department_store",
                 "shopping_mall"],
      attraction: ["casino",
                   "library",
                   "movie_theater",
                   "bowling_alley",
                   "amusement_park",
                   "museum",
                   "zoo",
                   "park",
                   "art_gallery",
                   "tourist_attraction"],
      food: ["bar",
             "cafe",
             "bakery",
             "restaurant",
             "night_club"] }
  end
end
