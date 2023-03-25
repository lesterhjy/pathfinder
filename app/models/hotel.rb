class Hotel < ApplicationRecord
  belongs_to :trip
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
  validates :name, :address, :start_time, :end_time, presence: true
end
