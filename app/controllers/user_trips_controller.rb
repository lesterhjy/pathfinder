class UserTripsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def destroy
    @usertrip = UserTrip.find(params[:id])
    @usertrip.destroy
    redirect_to trips_path
  end
end
