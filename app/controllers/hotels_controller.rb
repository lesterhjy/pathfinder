class HotelsController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
    @hotel = Hotel.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @hotel = Hotel.new(hotel_params)
    @hotel.trip = @trip
    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @trip }
        format.text { head :ok }
      else
        format.html
        format.text { render partial: "form", status: :unprocessable_entity, locals: { trip: @trip, hotel: @hotel }, formats: [:html] }
      end
    end
  end

  def edit
    @hotel = Hotel.find(params[:id])
    @trip = Trip.find(params[:trip_id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @hotel = Hotel.find(params[:id])
    @hotel.update(hotel_params)
    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @trip }
        format.text { head :ok }
      else
        format.html
        format.text { render partial: "form", status: :unprocessable_entity, locals: { trip: @trip, hotel: @hotel }, formats: [:html] }
      end
    end
  end

  def destroy
  end


  private

  def hotel_params
    params.require(:hotel).permit(:name,
                                  :address,
                                  :start_time,
                                  :end_time,
                                  :note,
                                  :trip_id)
  end
end
