require 'rails_helper'

describe HomeController, type: :controller, js: true do
  render_views
  it '#terms_and_conditions' do
    visit '/'
    click_link('T&C')
    expect(page)
    .to have_content('Thanks for using our products and services (“Services”).')
    find_link('gee@gigbazaar.com', href: /mailto\:gee@gigbazaar\.com/)
  end

  it '#privacy_policy' do
    visit '/'
    expect(page).to have_content('PRIVACY POLICY')
    click_link('Privacy policy')
    expect(page)
    .to have_content('You post Member Content (as defined in the Gig Bazaar Terms of Service)')
    all('a[href="mailto:gee@gigbazaar.com?subject=Gig%20Bazaar%2520Support"]',
        text: 'gee@gigbazaar.com', count: 2)
  end

  describe 'musicians search' do
    login_user

    let (:locations) { ["Лимбург, Нидерланды", "Лондон, Великобритания"] }

    before :each do
      2.times do | i |
        profile = FactoryGirl.create(:profile, user: User.last, location: locations[i - 1], profile_type: 1)
        genre = FactoryGirl.create(:genre)
        FactoryGirl.create(:service, profile: profile)
        MusicianGenre.create!(profile_id: profile.id, genre_id: genre.id)
      end
    end

    it 'checks correct user sort' do
    post :search_musicians, { location: "Лондон, Великобритания", genres: Genre.pluck(:id).join(',') }
    expect { assigns(:profiles).blank? }.to_not raise_error(ActiveRecord::StatementInvalid)
    assigns(:profiles).each do | p |
      expect(Profile.pluck(:id)).to include(p.id)
    end
    end

  end
end
