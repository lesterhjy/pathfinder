class CreateEventsJob < ApplicationJob
  require "json"
  require "open-uri"
  queue_as :default

  def perform(trip)
    # Sidekiq performs jobs at least once, and not only once. So it will queue up the same jobs multiple times.
    # To prevent Sidekiq from running the process multiple times, Trips now have a "created_events" attribute.
    # The first job queed by Sidekiq will flip the attribute to "True", and prevent the other jobs from running.
    return if trip.created_events

    trip.update(created_events: true)
    @recommended_events = []
    categories = search_categories
    categories.each_value do |group|
      group.each do |category|
        get_nearby_recommendations(category, trip)
      end
    end
    @recommended_events = @recommended_events.uniq
    get_recommendation_details(@recommended_events, trip)
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

  def get_nearby_recommendations(category, trip)
    location = "#{trip.latitude}%2C#{trip.longitude}"
    radius = '50000'

    nearby_search = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=#{radius}&type=#{category}&key=#{ENV["GOOGLE_API_KEY"]}")
    nearby_search_results = JSON.parse(URI.open(nearby_search).read)

    nearby_search_results["results"].first(3).each do |result|
      @recommended_events.append(result["place_id"])
    end
  end

  def get_recommendation_details(recommendations_overview, trip)
    recommendations_overview.each do |recommendation|
      place_details_search = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{recommendation}&key=#{ENV["GOOGLE_API_KEY"]}")
      place_details = JSON.parse(URI.open(place_details_search).read)["result"]
      if place_details.key?("photos")
        event = Event.new
        event.trip = trip
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
        event.save
      end
    end
  end
end
