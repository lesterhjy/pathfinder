class RemoveEndTimeFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :end_time, :string
  end
end
