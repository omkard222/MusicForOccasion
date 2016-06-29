class ProfileMailer < ApplicationMailer
  #default from: "brautaray@enbake.com"
  default from: "support@gigbazaar.com"
  def paypal_confirmation(profile)
  	@name = profile.musician? ? profile.stage_name : profile.username
  	@id = profile.id
  	@token = profile.paypal_account_email_confirmation_token
    mail(to: profile.paypal_account_email, subject: t('.paypal_email_confirmation'))
  end

  def invite_mail(profile, name, email)
  	#raise email.inspect
  	@email = email
  	@name = name 
    mail(to: email, subject: "send mail")
  end

  def facebook_connect_success
  	 mail(to: "gkumar@enbake.com", subject: "send mail") 
  end 


end
