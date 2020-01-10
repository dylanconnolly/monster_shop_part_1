class Coupon < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true
  validates_presence_of :percent_off
  validates :percent_off, numericality: { greater_than: 0, less_than_or_equal_to: 100}


  belongs_to :merchant
end
