class Trip < ApplicationRecord
  geocoded_by :destination
  after_validation :geocode, if: :will_save_change_to_destination?
  has_many :flights
  has_many :hotels
  has_many :events
  has_many :users
end
