# helper file for capybara tests
module CapybaraHelpers

  def login(user, password = nil)
    visit '/users/sign_in'
    fill_in 'user_email',    with: user.email
    fill_in 'user_password', with: password || 'password'
    click_button 'Log in'
  end

  def login_admin(admin)
    visit '/admins/sign_in'
    fill_in 'Email',    with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'
  end

  def send_message_to(user, msg = 'Lorem ipsum')
    visit '/'
    click_link user.username
    click_link 'Send message'
    fill_in 'msg_body', with: msg
    click_button 'Send'
  end

  def select_date(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), from: "#{field}_1i"  # year
    select date.strftime('%B'), from: "#{field}_2i"  # month
    select date.strftime('%-d'), from: "#{field}_3i" # day
  end

  def request(service, date)
    visit '/'
    click_link service.headline
    click_link 'Send Booking Request'
    find('#booking_request_date').set(date.strftime('%d/%m/%Y %H:%M'))
    click_button 'Send Booking Request'
  end

  def send_special_offer_to(username, service)
    first(:link, 'Dashboard').click
    click_link username
    click_link 'Send message'
    select service.headline, from: 'booking_request_service_id'
    fill_in 'booking_request_special_price', with: '111'
    find('#booking_request_date').set 1.day.from_now.strftime('%d/%m/%Y %H:%M')
    click_button 'Send Special Offer'
  end

  def sign_out
    visit '/'
    click_link 'Sign Out'
  end

  def screenshot(num = nil)
    page.driver.browser.render("#{Rails.root}/tmp/capybara/screenshot#{num}.png", 1024, 768)
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
end
