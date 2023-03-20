class FlightsController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @flight = Flight.new(flight_params)
    @flight.trip = @trip
    raise
    if @flight.save!
      redirect_to @trip
    else
      render :new, status: :unprocessable_entity
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
