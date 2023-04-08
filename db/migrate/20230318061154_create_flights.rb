class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights, id: :uuid do |t|
      t.time :start_time
      t.time :end_time
      t.string :departure_city
      t.string :arrival_city
      t.string :flight_number
      t.uuid :trip_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
