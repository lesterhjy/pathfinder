class AddSkipToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :skip, :boolean, default: false
  end
end
