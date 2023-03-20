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
        format.json # Follow the classic Rails flow and look for a create.json view
      else
        format.html { render "flights/form", status: :unprocessable_entity }
        format.json { render "flights/create.json.jbuilder", status: :unprocessable_entity }
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
    params.require(:flight).permit(:start_date,
                                  :start_time,
                                  :end_date,
                                  :end_time,
                                  :departure_city,
                                  :arrival_city,
                                  :flight_number,
                                  :note)
  end
end
