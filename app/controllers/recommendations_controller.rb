class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  require "json"
  require "open-uri"

  def index
    @flight = Flight.new
    @hotel = Hotel.new
    @trip = Trip.find(params[:trip_id])
    @categories = search_categories
    @categories.each_value do |categories|
      categories.each do |category|
        get_recommendation_details(get_nearby_recommendations(category))
      end
    end
    @recommendations = Event.where(trip_id: params[:trip_id])
  end

  private

  def search_categories
    { food: ["bar",
             "cafe",
             "bakery",
             "restaurant",
             "night_club"],
      shopping: ["book_store",
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
                   "tourist_attraction"] }
  end

  def get_nearby_recommendations(category)
    location = "#{@trip.latitude}%2C#{@trip.longitude}"
    radius = '30000'

    nearby_search = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=#{radius}&type=#{category}&key=#{ENV["GOOGLE_API_KEY"]}")
    nearby_search_results = JSON.parse(URI.open(nearby_search).read)

    recommendations_overview = []
    nearby_search_results["results"].each do |result|
      recommendations_overview.append(result["place_id"])
    end

    recommendations_overview
  end

  def get_recommendation_details(recommendations_overview)
    recommendations_overview.first(2).each do |recommendation|
      place = {}
      place_details_search = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{recommendation}&key=#{ENV["GOOGLE_API_KEY"]}")
      place_details = JSON.parse(URI.open(place_details_search).read)["result"]
      if place_details.key?("photos")
        Event.find_or_create_by(source_id: place_details["place_id"]) do |event|
          event.trip = @trip
          event.name = place_details["name"]
          event.source = 'google'
          event.source_id = place_details["place_id"]
          event.latitude = place_details["geometry"]["location"]["lat"]
          event.longitude = place_details["geometry"]["location"]["lng"]
          event.address = place_details["formatted_address"]
          event.category = place_details["types"]
          event.website = place_details["website"] if place_details.key?("website")
          event.phone = place_details["international_phone_number"] if place_details.key?("international_phone_number")
          event.photo = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=#{place_details["photos"][0]["photo_reference"]}&key=#{ENV["GOOGLE_API_KEY"]}"
          event.rating = place_details["rating"]
          event.review = place_details["reviews"]
          event.description = place_details["editorial_summary"]["overview"].capitalize if place_details.key?("editorial_summary")
        end
      end
    end
  end
end
