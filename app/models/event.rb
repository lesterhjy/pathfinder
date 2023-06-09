class Event < ApplicationRecord
  belongs_to :trip
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  acts_as_list
  validates :name, presence: true
end
