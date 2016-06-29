require 'rails_helper'

describe ServicesController, type: :controller, js: true do
  render_views
  let(:user1) { User.first }
  let(:user2) { User.last }
  before(:each) do |variable|
    create(:valid_user)
    create(:valid_user)
    login(user1)
  end

  it '#find_service' do
    create(:profile, user: user1, current: true)
    service1 = user1.profiles.first.services.first
    service2 = user1.profiles.last.services.first
    service3 = user2.profiles.first.services.first
    visit edit_service_path(service1)
    expect(page).to have_content('Your access has been denied !')
    visit edit_service_path(service2)
    expect(page).to have_content('Update Offer')
    visit edit_service_path(service3)
    expect(page).to have_content('Your access has been denied !')
  end

end
