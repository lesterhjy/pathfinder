class Flight < ApplicationRecord
  belongs_to :trip
  validates :departure_city, presence: true
end
