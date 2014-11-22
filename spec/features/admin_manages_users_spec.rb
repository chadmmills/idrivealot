require 'spec_helper'

feature "An Admin" do
  context "while signed in" do
    scenario "can see a list of users" do
    admin = create(:admin)
    visit new_admin_session_path

    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Login"

    expect(page).to have_content "Users"

    end
  end
end
