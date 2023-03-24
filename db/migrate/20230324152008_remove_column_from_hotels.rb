class RemoveColumnFromHotels < ActiveRecord::Migration[7.0]
  def change
    remove_column :hotels, :note, :string
  end
end
