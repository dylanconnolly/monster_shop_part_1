class Coupon < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true
  validates_presence_of :percent_off

  belongs_to :merchant
end