class DragController < ApplicationController

  def event
    @event = Event.find(drag_event_params[:id])
    @events = Event.all
    @events_that_day = @events.order(:position).select { |event| event.start_time.day == @event.start_time.day }
    old_index = @events_that_day.index(@event)
    old_position = @event.position
    new_index = drag_event_params[:position].to_i
    new_position = old_position + (new_index - old_index)
    @event.insert_at(new_position - 1)
  end

  private

  def drag_event_params
    params.require(:resource).permit(:id, :position)
  end

end
