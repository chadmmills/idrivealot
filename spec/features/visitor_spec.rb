require 'spec_helper'

feature 'Visitor' do
  scenario "will be shown the home screen on first visit" do
    visit root_path
    expect(page).to have_content "idrivealot.com"
  end
end
