class CreateUserTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :user_trips, id: :uuid do |t|
      t.uuid :user_id, null: false, foreign_key: true
      t.uuid :trip_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
