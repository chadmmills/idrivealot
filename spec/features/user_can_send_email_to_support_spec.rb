require 'rails_helper'

feature "User needs help" do
  scenario "can send email to support" do
    user = create(:user)
    visit new_user_session_path
    fill_in "Email", with: "email@example.com"
    fill_in "Password", with: "password123"
    click_button "Login"

    visit user_help_path
    expect(page).to have_content "Contact Support"
  end
end
