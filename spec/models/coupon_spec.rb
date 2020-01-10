require 'rails_helper'

RSpec.describe Coupon do
  describe "validations" do
    it {should validate_presence of :name}
    it {should validate_presence of :code}
    it {should validate_presence of :percent_off}
    it {should validate_uniqueness_of :name}
    it {should validate_uniqueness_of :code}
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
