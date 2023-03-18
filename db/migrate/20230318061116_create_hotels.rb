class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.time :start_time
      t.time :end_time
      t.string :note
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
