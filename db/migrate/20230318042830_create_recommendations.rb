class CreateRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations, id: :uuid do |t|
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
      t.string :review
      t.string :description

      t.timestamps
    end
  end
end
