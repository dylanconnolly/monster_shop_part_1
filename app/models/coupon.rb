class Coupon < ApplicationRecord
  validates_presence_of :name, uniqueness: true
  validates_presence_of :code, uniqueness: true
  validates_presence_of :percent_off
end
