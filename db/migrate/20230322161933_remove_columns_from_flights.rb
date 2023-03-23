class RemoveColumnsFromFlights < ActiveRecord::Migration[7.0]
  def change
    remove_column :flights, :start_time, :time
    remove_column :flights, :end_time, :time
    remove_column :flights, :start_date, :string
    remove_column :flights, :end_date, :string
  end
end
