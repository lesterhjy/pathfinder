class RemoveStartDateFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :start_date, :string
  end
end
