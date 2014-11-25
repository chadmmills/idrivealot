require 'spec_helper'

feature "An Admin" do
  context "while signed in" do
    scenario "can see a list of coupn codes" do
      login create(:admin)

      #click_link "Coupons"
      #expect(page).to have_content "Coupons"

    end
  end
end

def login(user)
  visit new_admin_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end
