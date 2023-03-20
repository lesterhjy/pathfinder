class AddDatesToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :start_date, :string
    add_column :flights, :end_date, :string
  end
end
