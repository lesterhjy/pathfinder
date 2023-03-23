class Trip < ApplicationRecord
  has_many :flights, dependent: :destroy
  has_many :hotels, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :users
end
