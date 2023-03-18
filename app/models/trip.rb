class Trip < ApplicationRecord
  has_many :flights
  has_many :hotels
  has_many :events
  has_many :users
end
