class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @flight = Flight.new
    @hotel = Hotel.new
    @trip = Trip.find(params[:trip_id])
    @days = (@trip.start_date.to_datetime..@trip.end_date.to_datetime).to_a.length
    @categories = search_categories
    if @trip.events.empty?
      CreateEventsJob.perform_later(@categories, @trip)
    end
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
