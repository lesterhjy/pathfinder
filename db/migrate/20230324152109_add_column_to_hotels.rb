class AddColumnToHotels < ActiveRecord::Migration[7.0]
  def change
    add_column :hotels, :note, :text
  end
end
