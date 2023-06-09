class FlightsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def create
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.new(flight_params)
    @flight.trip = @trip
    flight_save
  end

  def edit
    @flight = Flight.find(params[:id])
    @trip = Trip.find(params[:trip_id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.find(params[:id])
    @flight.update(flight_params)
    flight_save
  end

  def destroy
  end

  private

  def flight_save
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
