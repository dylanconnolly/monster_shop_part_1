require 'rails_helper'

RSpec.describe "user registration" do
  it "allows user to complete a form and register as a user" do

    visit '/'

    click_on "Register"

    fill_in "Name", with: "Gertrude"
    fill_in "Street Address", with: "123 Street Rd."
    fill_in "City", with: "Waco"
    fill_in "State", with: "TX"
    fill_in "Email Address", with: "gertrude@praisebetogertrude.org"
    fill_in "Password", with: "Gertrude1"
    fill_in "Confirm Password", with: "Gertrude1"

    click_on "Submit"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, Gertrude!")
  end
end
