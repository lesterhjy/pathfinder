class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @trip = Trip.find(params[:trip_id])
    # creating association with trip and user
    unless UserTrip.where(user_id: current_user.id, trip_id: @trip.id).exists?
      UserTrip.create(user_id: current_user.id, trip_id: @trip.id)
    end
    @flight = Flight.new
    @hotel = Hotel.new
    @flight_count = @trip.flights.count
    @hotel_count = @trip.hotels.count
    @days = (@trip.start_date.to_datetime..@trip.end_date.to_datetime).to_a.length
    @categories = search_categories
    CreateEventsJob.perform_later(@trip) if @trip.events.empty?
    @recommendations = Event.where(trip_id: params[:trip_id])
    respond_to do |format|
      format.html
      format.text { render partial: "recommendations/recommendation_list", locals: {recommendations: @recommendations}, formats: [:html] }
    end
  end

  private

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
