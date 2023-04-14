class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }

  has_many :posts
  has_many :attendances
  has_many :attended_events, through: :attendances, source: :event
end
