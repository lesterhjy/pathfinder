class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
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
      t.string :review
      t.string :note
      t.string :start_date
      t.string :end_date
      t.string :start_time
      t.string :end_time
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
