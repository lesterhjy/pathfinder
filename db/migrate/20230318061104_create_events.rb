class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name
      t.string :source
      t.string :source_id
      t.string :lat
      t.string :lng
      t.string :category
      t.string :address
      t.string :website
      t.string :phone
      t.string :email
      t.string :photo
      t.string :rating
      t.string :note
      t.time :start_time
      t.time :end_time
      t.string :review
      t.uuid :trip_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
