if @flight.persisted?
  json.form render(partial: "flights/form", formats: :html, locals: {trip: @trip, flight: Flight.new})
else
  json.form render(partial: "flights/form", formats: :html, locals: {trip: @trip, flight: @flight})
end
