class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :password, :password_confirmation
  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
end
