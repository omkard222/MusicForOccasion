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
  	@profile = profile
    @slug = @profile.id
  	@email = email
  	@name = name
  	@account_name = profile.user.first_name
    @profile_name = profile.stage_name 
    mail(to: email, subject: "Invitation from #{@account_name} to connect with gigbazaar")
    #mail(to: "rupinder.enbake@gmail.com", subject: "invitation from #{@profile.stage_name} to connect with gigbazaar")
  end

  def invite_twitter_mail(profile, name, email)
    @profile = profile
    @slug = @profile.id
    @email = email
    @name = name
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name 
    mail(to: email, subject: "Invitation from #{@account_name} to connect with gigbazaar")
    #mail(to: "rupinder.enbake@gmail.com", subject: "invitation from #{@profile.stage_name} to connect with gigbazaar")
  end

  def facebook_connect_success_user(profile, name, email)
  	@profile = profile
  	@email = email
  	@name = name
  	@account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @slug = @profile.id 
    mail(to: email, subject: "connected #{@account_name} with facebook successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "connected #{@name} with facebook successfully") 
  end 
  def facebook_connect_success_profile(profile, name, email)
  	@profile = profile
  	@email = email
  	@name = name
    @slug = @profile.id
  	@account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @profile_email = profile.user.email 
    mail(to: @profile_email, subject: "connected #{@account_name} with facebook successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "connected #{@name} with facebook successfully") 
  end

  def facebook_disconnect_success_user(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @slug = @profile.id
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name 
    mail(to: @email, subject: "disconnected #{@account_name} with facebook successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "disconnected #{@name} with facebook successfully")
  end 

  def facebook_disconnect_success_profile(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @slug = @profile.id
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @profile_email = profile.user.email
    mail(to: @profile_email, subject: "disconnected #{@account_name} with facebook successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "disconnected #{@name} with facebook successfully")
  end 

  def twitter_connect_success_user(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @slug = @profile.id 
    mail(to: email, subject: "connected #{@account_name} with Twitter successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "connected #{@name} with twitter successfully") 
  end 
  def twitter_connect_success_profile(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @slug = @profile.id
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @profile_email = profile.user.email 
    mail(to: @profile_email, subject: "connected #{@account_name} with Twitter successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "connected #{@name} with twitter successfully") 
  end

  def twitter_disconnect_success_user(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @slug = @profile.id
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name 
    mail(to: @email, subject: "disconnected #{@name} with Twitter successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "disconnected #{@name} with twitter successfully")
  end 

  def twitter_disconnect_success_profile(profile, name, email)
    @profile = profile
    @email = email
    @name = name
    @slug = @profile.id
    @account_name = profile.user.first_name
    @profile_name = profile.stage_name
    @profile_email = profile.user.email
    mail(to: @profile_email, subject: "disconnected #{@name} with Twitter successfully")
    #mail(to: "rupinder.enbake@gmail.com", subject: "disconnected #{@name} with twitter successfully")
  end 
 
   
   def profile_mail_previous(profile, old_user, new_user)
    @profile = profile
    @old_user = old_user
    @new_user = new_user
    @profile_name = profile.user.first_name
    old_email = @old_user.email  
    mail(to: old_email, subject: "Migration of Profile successful")
    #mail(to: "brautaray@enbake.com", subject: "Migration of Profile successful")
  end
  def profile_mail_current(profile, old_user, new_user)
    @profile = profile
    @old_user = old_user
    @new_user = new_user
    @profile_name = profile.user.first_name
    new_email = @new_user.email  
    mail(to: new_email, subject: "Migration of Profile successful")
    #mail(to: "brautaray@enbake.com", subject: "Migration of Profile successful")
  end

end
