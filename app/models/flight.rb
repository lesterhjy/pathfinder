class Flight < ApplicationRecord
  belongs_to :trip
  validates :start_time, :end_time, :departure_city, :arrival_city, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
end
