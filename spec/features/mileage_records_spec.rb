require 'spec_helper'

feature "User" do
	scenario "can save a new mileage record" do
		user = create(:user, email: 'ugh@example.com')
		signin user
		fill_in 'new_route_description', with: "Store 89"
		fill_in 'Start Mileage', with: 1
		fill_in 'End Mileage', with: 23
		click_button 'SAVE'
		expect(page).to have_content "Last Saved:"
		expect(page).to have_content "Store 89"
	end	

	scenario "can update an existing record" do
		user = create(:user, email: 'update@exmaple.com')
		existing_mileage_record = create(:mileage_record, user: user)
		signin user	
		fill_in 'new_route_description', with: "JK Store 92"
		click_button "SAVE"
		expect(page).to have_content "JK Store 92"
	end

	scenario "can see a list of mileage records" do
		user = create(:user, email: 'update@exmaple.com')
		mileage_record_1 = create(:mileage_record, user: user)
		mileage_record_2 = create(:mileage_record, user: user)
		signin user	
		click_link "LIST VIEW"
		expect(page).to have_content mileage_record_1.route_description
		expect(page).to have_content mileage_record_2.route_description
	end

	scenario "can update their login information" do
		user = create(:user, email: 'update@exmaple.com')
		signin user	
		click_link "EDIT PROFILE"
		fill_in 'Email', with: 'newemail@example.com'
		fill_in 'Current password', with: user.password
		click_button "Update"
		expect(page).to have_content "successfully"
	end
end

def signin user
	visit root_path
	fill_in 'Email', with: user.email
	fill_in 'Password', with: user.password
	click_button "LOGIN"
end
