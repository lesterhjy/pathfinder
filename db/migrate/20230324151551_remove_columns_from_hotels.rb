class RemoveColumnsFromHotels < ActiveRecord::Migration[7.0]
  def change
    remove_column :hotels, :start, :datetime
    remove_column :hotels, :end, :datetime
  end
end
