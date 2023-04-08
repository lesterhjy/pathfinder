class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  require "json"
  require "open-uri"

  def home
    @trip = Trip.new
  end
end
