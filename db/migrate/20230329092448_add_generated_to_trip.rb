class AddGeneratedToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :generated, :boolean
  end
end
