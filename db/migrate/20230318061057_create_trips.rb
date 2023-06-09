class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips, id: :uuid do |t|
      t.string :destination
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
