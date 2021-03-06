require 'rails_helper'

RSpec.describe "as a merchant admin" do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    @merchant_admin = @meg.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
  end

  it "I see a link to manage coupons from my dashboard" do

    visit '/merchant'

    click_link("Manage Coupons")

    expect(current_path).to eq("/merchant/coupons")
  end

  it "I can create a new coupon from the coupon index" do

    visit '/merchant/coupons'

    click_link("Create New Coupon")

    fill_in :coupon_name, with: "Summer Deal"
    fill_in :coupon_code, with: "SUMMER20"
    fill_in :coupon_percent_off, with: 20

    click_on "Create Coupon"

    coupon = Coupon.last

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content(coupon.name)
    expect(page).to have_content(coupon.code)
    expect(page).to have_content(coupon.percent_off)
  end

  it "I receive a flash error if coupon form is not complete, name/code is not unique, percent is not between 0 and 100" do
    visit '/merchant/coupons'

    click_link("Create New Coupon")

    fill_in :coupon_name, with: "Summer Deal"
    fill_in :coupon_code, with: "SUMMER20"

    click_on "Create Coupon"

    expect(page).to have_content("Percent off can't be blank")

    fill_in :coupon_percent_off, with: 0

    click_on "Create Coupon"

    expect(page).to have_content("Percent off must be greater than 0")

    fill_in :coupon_percent_off, with: 101

    click_on "Create Coupon"

    expect(page).to have_content("Percent off must be less than or equal to 100")

    fill_in :coupon_percent_off, with: 15

    click_on "Create Coupon"

    click_link("Create New Coupon")

    fill_in :coupon_name, with: "Summer Deal"
    fill_in :coupon_code, with: "SUMMER20"
    fill_in :coupon_percent_off, with: 25

    click_on "Create Coupon"

    expect(page).to have_content("Name has already been taken and Code has already been taken")
  end
end
