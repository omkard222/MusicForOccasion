# handle subsciption list with MAILCHIMP API
class NewslettersController < ApplicationController
  def subscribe
    subscribers = [{ 'EMAIL' => { 'email' => params[:email][:address] },
                     EMAIL_TYPE: 'html',
                     merge_vars: {}
                 }]
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.batch_subscribe(
      ENV['NEWSLETTER_SUBSCRIPTION_LIST_ID'],
      subscribers,
      false, true, false)
    render text: 'Thank you for your subscription.'
  end
end
