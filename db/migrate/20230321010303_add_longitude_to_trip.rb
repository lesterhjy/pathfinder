class AddLongitudeToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :longitude, :float
  end
end
