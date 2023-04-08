class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels, id: :uuid do |t|
      t.string :name
      t.string :address
      t.datetime :start_time
      t.datetime :end_time
      t.text :note
      t.uuid :trip_id, null: false, foreign_key: true
      t.timestamps
    end
  end
end
