require 'spec_helper'

feature "New Mileage Record" do
	scenario "only includes current_user select options" do
		user = create(:user)
		create(:mileage_record, route_description: "Hello there", user_id: 1308)
		create(:mileage_record, route_description: "This should show up", user: user)
		visit root_path
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'LOGIN'
		click_link "Edit"
		#save_and_open_page
		expect(page.source).to_not have_text "Hello there"
		expect(page.source).to have_text "This should show up"
		fill_in "new_route_description", with: "Trip to Honda"
		click_button 'EDIT ENTRY'
		expect(page).to have_content "Trip to Honda"
	end	
end

feature "Edit Mileage Record" do
	scenario "edit field for route description" do

	end
end
