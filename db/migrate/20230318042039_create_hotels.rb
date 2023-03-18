class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.string :start_date
      t.string :start_time
      t.string :end_date
      t.string :end_time
      t.string :note
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
