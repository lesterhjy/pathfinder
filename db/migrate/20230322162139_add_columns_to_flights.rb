class AddColumnsToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :start_time, :datetime
    add_column :flights, :end_time, :datetime
  end
end
