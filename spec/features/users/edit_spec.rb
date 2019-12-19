require 'rails_helper'

RSpec.describe 'User profile page' do
  it "I can see see my information and link to edit my profile" do

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)

    click_on("Edit your profile")
    expect(current_path).to eq('/profile/edit')
  end

  it "I can click a link that allows me to edit my profile through a form" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    click_link "Edit your profile"

    expect(find_field('Name').value).to eq "User"
    expect(find_field('Address').value).to eq "1230 East Street"
    expect(find_field('City').value).to eq "Boulder"
    expect(find_field('State').value).to eq "CO"
    expect(find_field('Zip').value).to eq '98273'
    expect(find_field('Email').value).to eq "user@user.com"

    fill_in :name, with: "Changed User"
    fill_in :address, with: "90210 Different Address Dr."
    fill_in :city, with: "Different City"
    fill_in :state, with: "TX"
    fill_in :zip, with: 70291
    click_button "Update Profile"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your profile has been updated.")
    expect(page).to have_content("Changed User")
    expect(page).to have_content("90210 Different Address Dr.")
    expect(page).to have_content("Different City")
    expect(page).to have_content("TX")
    expect(page).to have_content("70291")
    expect(page).to have_content("user@user.com")

    click_link "Edit your profile"
    fill_in :name, with: "Changed my name again"
    click_button "Update Profile"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Changed my name again")
    expect(page).to have_content("90210 Different Address Dr.")
    expect(page).to_not have_content("Changed User")
  end
end