require 'rails_helper'

feature "User" do
  scenario "can signup and pay with credit card" do
    stripe_helper = StripeMock.create_test_helper 
    StripeMock.start 
    stripe_helper.create_plan id: "idrivealot_monthly", name: "idrivealot_monthly"

    visit new_user_registration_path
    fill_in "Email", with: "email@example.com"
    fill_in "Password", with: "password123"
    find(:xpath, "//input[@id='user_stripe_card_token']").set stripe_helper.generate_card_token
    fill_in "card_number", with: "4242424242424242"
    fill_in "card_code", with: "123"
    select "12", from: "card_month"
    select Date.current.year + 1, from: "card_year"
    click_button "Sign Up"

    expect(page).to have_content "Welcome"

    StripeMock.stop 
  end

  context "with existing plan" do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    scenario "must input valid credit card if account is inactive" do
      user = create(:user, active: false)
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Login"

      expect(page).to have_content "Your account is locked"

      fill_in "card_number", with: "4242424242424242"
      fill_in "card_code", with: "123"
      select "12", from: "card_month"
      select Date.current.year + 1, from: "card_year"

      click_button "Update Payment Information"

    end
  end
end
