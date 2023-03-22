class AddColumnToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :note, :text
  end
end
