class AddEndDateToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :end_date, :date
  end
end