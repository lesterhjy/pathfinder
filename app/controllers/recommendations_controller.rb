class RecommendationsController < ApplicationController
  require "json"
  require "open-uri"

  def index
    @event = Event.new
    @recommendations = {}
    categories = ["bar", "cafe", "shopping_mall", "park", "tourist_attraction", "zoo", "museum"]
    categories.each do |category|
      @recommendations[category] = get_recommendation_details(get_nearby_recommendations(category))
    end
  end

  private

  def get_nearby_recommendations(category)
    location = '49.277812731849664%2C-123.13517911928503'
    radius = '30000'

    nearby_search = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=#{radius}&type=#{category}&key=AIzaSyBRH3Ee4ygRxpfyyyZ3llE_nEmbhRJBxjM")
    nearby_search_results = JSON.parse(URI.open(nearby_search).read)

    recommendations_overview = []
    nearby_search_results["results"].each do |result|
      recommendations_overview.append(result["place_id"])
    end

    recommendations_overview
  end

  def get_recommendation_details(recommendations_overview)
    recommendations = []
    recommendations_overview.first(3).each do |recommendation|
      place = {}
      place_details_search = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{recommendation}&key=AIzaSyBRH3Ee4ygRxpfyyyZ3llE_nEmbhRJBxjM")
      place_details = JSON.parse(URI.open(place_details_search).read)["result"]
      if place_details.key?("photos")
        place["name"] = place_details["name"]
        place["source"] = 'google'
        place["source_id"] = place_details["place_id"]
        place["lat"] = place_details["geometry"]["location"]["lat"]
        place["lng"] = place_details["geometry"]["location"]["lng"]
        place["address"] = place_details["formatted_address"]
        place["category"] = place_details["types"]
        place["website"] = place_details["website"] if place_details.key?("website")
        place["phone"] = place_details["international_phone_number"] if place_details.key?("international_phone_number")
        place["photo"] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=#{place_details["photos"][0]["photo_reference"]}&key=AIzaSyBRH3Ee4ygRxpfyyyZ3llE_nEmbhRJBxjM"
        place["rating"] = place_details["rating"]
        place["review"] = place_details["reviews"]
        place["description"] = place_details["editorial_summary"]["overview"].capitalize if place_details.key?("editorial_summary")
        recommendations.append(place)
      end
    end
    recommendations
  end

end
