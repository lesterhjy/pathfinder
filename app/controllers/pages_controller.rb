class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]
  require "json"
  require "open-uri"

  def home
    @trip = Trip.new
  end
end
