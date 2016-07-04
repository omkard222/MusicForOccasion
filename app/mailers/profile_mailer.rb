class ProfileMailer < ApplicationMailer
  #default from: "brautaray@enbake.com"
  default from: "support@gigbazaar.com"
  layout false
  def paypal_confirmation(profile)
  	@name = profile.musician? ? profile.stage_name : profile.username
  	@id = profile.id
  	@token = profile.paypal_account_email_confirmation_token
    mail(to: profile.paypal_account_email, subject: t('.paypal_email_confirmation'))
  end

  def invite_mail(profile, name, email)
  	#raise email.inspect
  	@profile = profile
  	@email = email
  	@name = name
  	@profile_name = profile.user.first_name 
    mail(to: email, subject: "Invition mail")
  end

  def facebook_connect_success_user(profile, name, email)
  	@profile = profile
  	@email = email
  	@name = name
  	@profile_name = profile.user.first_name 
    mail(to: email, subject: "Invition mail") 
  end 
  def facebook_connect_success_profile(profile, name, email)
  	@profile = profile
  	@email = email
  	@name = name
  	@profile_name = profile.user.first_name 
    mail(to: email, subject: "Invition mail") 
  end 
   
   def profile_mail_previous(profile, old_user, new_user)
    @profile = profile
    @old_user = old_user
    @new_user = new_user
    @profile_name = profile.user.first_name
    old_email = @old_user.email  
    #mail(to: old_email, subject: "Migration of Profile successful")
    mail(to: "rupinder.enbake@gmail.com", subject: "Migration of Profile successful")
  end
  def profile_mail_current(profile, old_user, new_user)
    @profile = profile
    @old_user = old_user
    @new_user = new_user
    @profile_name = profile.user.first_name
    new_email = @new_user.email  
    #mail(to: new_email, subject: "Migration of Profile successful")
    mail(to: "brautaray@enbake.com", subject: "Migration of Profile successful")
  end

end
