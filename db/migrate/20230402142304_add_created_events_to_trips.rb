class AddCreatedEventsToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :created_events, :boolean, null: false, default: false
  end
end
