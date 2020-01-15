require 'rails_helper'
# When I fill out all information on the new order page
# And click on 'Create Order'
# An order is created and saved in the database
# And I am redirected to that order's show page with the following information:
#
# - Details of the order:

# - the date when the order was created
RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 10000, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 200, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")

      within '.shipping-address' do
        expect(page).to have_content(name)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price/100.0}")
        expect(page).to have_content("2")
        expect(page).to have_content("$0.40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price/100.0}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price/100}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2.00")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $102.40")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at.strftime('%m/%d/%y'))
      end
    end

    it 'i cant create order if info not filled out' do
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_button("Create Order")
    end

    it 'registered users can checkout' do
      user = User.create!(name: "Polly Esther", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "veryoriginalemail@gmail.com", password: "polyester", password_confirmation: "polyester")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      name = "Bert"
      address = "123 Sesame St"
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Your order was created!")
      expect(page).to have_content("Order Number: #{new_order.id}")
      expect(page).to have_content("Order Status: pending")

    end

    it "if a user has input a coupon on the cart page, it is applied to the order" do
      coupon = @meg.coupons.create!(name: "Summer Deal", code: "SUMMER20", percent_off: 20)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/cart'

      fill_in :coupon_code, with: "SUMMER20"

      click_on "Apply"

      click_on "Checkout"

      fill_in :name, with: "Dylan"
      fill_in :address, with: "123 Street"
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: 12934

      click_on "Create Order"

      order = Order.last

      expect(order.coupon).to eq(coupon)
    end

  end
end
