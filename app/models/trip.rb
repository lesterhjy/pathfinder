class Trip < ApplicationRecord
  has_many :user_trips, dependent: :destroy
  has_many :flights, dependent: :destroy
  has_many :hotels, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :users, through: :user_trips
end
