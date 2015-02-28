require 'rails_helper'

feature "User" do
	scenario "will be asked to add their first entry on signup" do
		user = create(:user)
		signin user
		expect(page).to have_text "ADD YOUR FIRST ENTRY"
		expect(page).to_not have_text "SAVE"
	end

	scenario "can save a new mileage record" do
		user = create(:user, email: 'ugh@example.com')
		signin user
		click_link "ADD YOUR FIRST ENTRY"
		fill_in 'new_route_description', with: "Store 89"
		fill_in 'Start Mileage', with: 1
		fill_in 'End Mileage', with: 23
		click_button 'Save'
		expect(page).to have_content "Last Saved:"
		expect(page).to have_content "Store 89"
	end

	scenario "can save a record and go to next" do
		user = create(:user, email: 'ugh@example.com')
		signin user
		visit new_mileage_record_path
		fill_in 'new_route_description', with: "Store 89"
		fill_in 'Start Mileage', with: 1
		fill_in 'End Mileage', with: 23
		click_button 'Save & Add New'
		expect(page).to have_content "New Entry"
	end

	scenario "can update an existing record" do
		user = create(:user, email: 'update@exmaple.com')
		existing_mileage_record = create(:mileage_record, user: user)
		signin user
		fill_in 'new_route_description', with: "JK Store 92"
		click_button "Save"
		expect(page).to have_content "JK Store 92"
	end

	scenario "can see a list of mileage records" do
		user = create(:user, email: 'update@exmaple.com')
		mileage_record_1 = create(:mileage_record, user: user)
		mileage_record_2 = create(:mileage_record, user: user)
		signin user
		click_link "List"
		expect(page).to have_content mileage_record_1.route_description
		expect(page).to have_content mileage_record_2.route_description
		expect(page).to_not have_content mileage_record_1.created_at
	end

  describe "Stripe" do
    
  end
	scenario "can update their login information" do
		user = create(:user, email: 'update@exmaple.com')
		signin user
		click_link "Edit Profile"
		fill_in 'Email', with: 'newemail@example.com'
		fill_in 'Current password', with: user.password
		click_button "Update Account"
		expect(page).to have_content "successfully"
	end

	scenario "can view stats regarding their entries" do
		user = create(:user, email: 'update@exmaple.com')
		ml = create(:mileage_record, user: user, end_mileage: 200)
		ml2 = create(:mileage_record, user: user, start_mileage: 200, end_mileage: 410)
		signin user
		click_link "Stats"
		expect(page).to have_content "410"
	end

  scenario "can download existing records" do
		user = create(:user, email: 'update@exmaple.com')
		ml = create(:mileage_record, user: user, end_mileage: 200)
		ml2 = create(:mileage_record, user: user, start_mileage: 200, end_mileage: 410)
		signin user
		click_link "Download"
    expect(page).to have_content "Download"
  end

  scenario "can send data report in email" do
		user = create(:user, email: 'update@exmaple.com')
		ml = create(:mileage_record, user: user, end_mileage: 200, record_date: Date.yesterday)
		ml2 = create(:mileage_record, user: user, start_mileage: 200, end_mileage: 410, record_date: Date.today)
		signin user
		click_link "Download"
    
    select Date.today.strftime('%B'), from: "date_month"
    check "email_flag"
    click_button "Download Excel File"

    expect(page).to have_content "Email Sent!"
  end

end

def signin user
	visit new_user_session_path
	fill_in 'Email', with: user.email
	fill_in 'Password', with: user.password
	click_button "Login"
end
