class EventsController < ApplicationController
  def create
    @event = Event.new(event_params)
    @event.save!

    respond_to do |format|
      format.html
      format.text { render partial: "recommendations/recommendation_added", formats: [:html] }
    end
  end

  private

  def event_params
    params.require(:event).permit(:name,
                                  :source,
                                  :source_id,
                                  :lat,
                                  :lng,
                                  :address,
                                  :category,
                                  :website,
                                  :phone,
                                  :photo,
                                  :rating,
                                  :review,
                                  :description)
  end
end
