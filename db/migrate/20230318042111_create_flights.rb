class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.string :start_date
      t.string :start_time
      t.string :end_date
      t.string :end_time
      t.string :departure_city
      t.string :arrival_city
      t.string :flight_number
      t.string :note
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
