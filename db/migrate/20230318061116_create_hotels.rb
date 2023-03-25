class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.datetime :start_time
      t.datetime :end_time
      t.text :note
      t.references :trip, null: false, foreign_key: true
      t.timestamps
    end
  end
end
