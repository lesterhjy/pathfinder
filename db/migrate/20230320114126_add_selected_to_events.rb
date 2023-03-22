class AddSelectedToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :selected, :boolean
  end
end
