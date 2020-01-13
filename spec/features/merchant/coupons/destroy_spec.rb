require 'rails_helper'

RSpec.describe "as a merchant admin" do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    @merchant_admin = @meg.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    @coupon_1 = @meg.coupons.create!(name: "Summer Deal", code: "SUMMER20", percent_off: 20)
    @coupon_2 = @meg.coupons.create!(name: "Spring Sale", code: "SPRING", percent_off: 15)

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 2, coupon: @coupon_1)

    @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = @order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 3)
  end

  it "I have the ability to delete a coupon from the coupon index page if the coupon has not been used in an order" do

    visit '/merchant/coupons'

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to_not have_link("Delete Coupon")
    end

    within "#coupon-#{@coupon_2.id}" do
      click_link("Delete Coupon")
    end

    expect(page).to_not have_content(@coupon_2.name)
  end
end
