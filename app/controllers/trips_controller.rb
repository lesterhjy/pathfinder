class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_trip, only: [:show]

  def create
    @trip = Trip.new(trip_params)
    @trip.save
    redirect_to trip_recommendations_path(@trip)
  end

  def show
    # @testEvents = Event.where(trip: @trip, note: 'self-created')
    @event = Event.new
    # @categories = search_categories
    # @categories.each_value do |categories|
    #   categories.each do |category|
    #     get_recommendation_details(get_nearby_recommendations(category))
    #   end
    # end
    @recommendations = Event.where(trip: @trip, note: [nil, ""])
    # pick the trip's events, order by position, and select only those that the user has selected
    @events = @trip.events.order(:start_time, :position).select { |event| (event.selected == true) and event.start_time }
    # events for the first day - will show as default on the trip show page
    @first_day_events = @events.group_by { |event| event.start_time.day }.values[0]
    # all events - this is used for the tab info only for now
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
    # when a tab is clicked, it will send a request to get the day's events
    if params[:day].present?
      @events = @events.select { |event| event.start_time.day == params[:day].to_i }
    end

    respond_to do |format|
      format.html
      # this renders the tab info when you click on a specific day
      format.text { render partial: 'trips/events', locals: { events: @events }, formats: [:html] }
    end
  end

  def overview
    @trip = Trip.find(params[:trip_id])
    # select the events selected by user
    @events = @trip.events.order(:position).select { |event| event.selected == true }
    @events_by_day = @events.sort_by { |e| [e.start_time, e.position] }
                            .group_by { |event| event.start_time.day }.values
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :latitude, :longitude)
  end

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
          event.start_time = @trip.start_date #to delete later
          event.description = place_details["editorial_summary"]["overview"].capitalize if place_details.key?("editorial_summary")
        end
      end
    end
  end


end
