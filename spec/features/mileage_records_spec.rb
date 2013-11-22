require 'spec_helper'

feature "New Mileage Record" do
	scenario "only includes current_user select options" do
		user = create(:user)
		create(:mileage_record, route_description: "Hello there", user: user)
		visit root_path
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'Sign in'
		click_link "New Mileage Record"
		# save_and_open_page
		expect(page.source).to_not have_text "Hello there"
	end	
end