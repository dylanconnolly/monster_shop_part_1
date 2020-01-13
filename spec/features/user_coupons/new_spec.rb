require 'rails_helper'

RSpec.describe "users can use coupons" do
  describe "on the cart page the user sees a field to input a coupon code" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]

      @coupon_1 = @meg.coupons.create!(name: "Summer Deal", code: "SUMMER20", percent_off: 20)
      @coupon_2 = @meg.coupons.create!(name: "Spring Sale", code: "SPRING", percent_off: 15)
    end

    it "the user can input a code and the system checks if there is a coupon_code that matches" do

      visit '/cart'

      fill_in :coupon_code, with: "SUMMER20"

      click_on "Apply"

      expect(page).to have_content("Coupon code applied!")

      fill_in :coupon_code, with: "FAKECODE"

      click_on "Apply"

      expect(page).to have_content("Invalid coupon code.")
    end
  end
end
