class User < ApplicationRecord
  has_many :user_trips, dependent: :destroy
  has_many :trips, through: :user_trips
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
