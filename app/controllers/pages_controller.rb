class PagesController < ApplicationController
  require "json"
  require "open-uri"
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @trip = Trip.new
  end
end
