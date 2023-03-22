class AddLatitudeToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :latitude, :float
  end
end
