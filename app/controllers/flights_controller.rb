class FlightsController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.new(flight_params)
    @flight.trip = @trip
    respond_to do |format|
      if @flight.save
        format.html { redirect_to @trip }
        format.text { head :ok }
      else
        format.html
        format.text { render partial: "form", status: :unprocessable_entity, locals: { trip: @trip, flight: @flight }, formats: [:html] }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def flight_params
    params.require(:flight).permit(:start_time,
                                   :end_time,
                                   :departure_city,
                                   :arrival_city,
                                   :flight_number,
                                   :note,
                                   :trip_id)
  end
end
