class AddPositionToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :position, :integer
    Event.order(:start_time).each.with_index(1) do |event, index|
      event.update_column :position, index
    end
  end
end
