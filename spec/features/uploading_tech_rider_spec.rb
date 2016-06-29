require 'rails_helper'

feature "Upload tech rider by musician user" do

  background do
    user = User.create!(email: 'musician@example.com', password: 'password')
    user = Profile.create!(username: 'musician', stage_name: 'stage name', profile_type: 1, user_id: user.id)
  end

  scenario "Profile info for musician have got no tech rider", js: true do
    user = User.find_by(email: 'musician@example.com')
    login(user, 'password')
    expect(page).to_not have_content 'Tech rider'
  end

  scenario "Upload tech rider by musician", js: true do
    user = User.find_by(email: 'musician@example.com')
    login(user, 'password')
    visit edit_profile_path(user.profiles.first)
    expect(page).to have_selector '#upload_tech_rider'
    page.execute_script('$("#profile_tech_rider_input").removeClass("hidden_field")')
    expect(page).to have_selector '#profile_tech_rider'
    attach_file('profile_tech_rider', './spec/fixtures/gigBazaar_test.pdf')
    expect(page).to have_content 'gigBazaar_test.pdf'
    expect(page).to have_selector 'a#delete_profile_tech_rider'
    click_button 'Update profile'
    expect(page).to have_content "Successfully updated profile's details."
    expect(page).to have_content 'Tech rider: Download'
  end

  scenario "Delete existing tech rider by musician", js: true do
    user = User.find_by(email: 'musician@example.com')
    login(user, 'password')
    visit edit_profile_path(user.profiles.first)
    page.execute_script('$("#profile_tech_rider_input").removeClass("hidden_field")')
    attach_file('profile_tech_rider', './spec/fixtures/gigBazaar_test.pdf')
    click_button 'Update profile'
    visit edit_profile_path(user.profiles.first)
    expect(page).to have_selector 'a#delete_profile_tech_rider'
    expect(page).to have_content 'gigBazaar_test.pdf'
    find('a#delete_profile_tech_rider').trigger('click')
    expect(page).to_not have_content 'gigBazaar_test.pdf'
    click_button 'Update profile'
    expect(page).to have_content "Successfully updated profile's details."
    expect(page).to_not have_content('Tech rider')
  end
end
