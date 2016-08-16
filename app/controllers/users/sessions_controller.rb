module Users
  # Customized to accept extra fileds.
  class SessionsController < Devise::SessionsController
    include ApplicationHelper
    before_filter :permit_devise_parameters
    skip_before_filter :set_booker_profile, :only => [:destroy]
    # POST /user/sign_in
    def create
      logging_user = User.where(email: params[:user][:email]).first
      if logging_user
        return redirect_to new_profile_path(user: logging_user), alert: t('.profilize') unless logging_user.profiles.present?
      end
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      if resource.is_musician?
        if resource.profiles
          if session[:try_book]
            profile_id = session[:try_book]
            session[:try_book] = nil
            redirect_to profile_path(profile_id)
          else
            if resource.current_profile.present?
              redirect_to profile_path(resource.current_profile.id)
            else
              redirect_to profiles_path
            end
          end
        else
          session[:try_book] = nil if session[:try_book]
          redirect_to new_profile_path
        end
      else
        if session[:try_book]
          profile_id = session[:try_book]
          session[:try_book] = nil
          redirect_to profile_path(profile_id)
        else
          if resource.profiles.count == 1
            redirect_to profile_type_profiles_path(type: 'registered_user', edit: false)
          else 
            redirect_to root_path
          end   
        end
      end
      yield resource if block_given?
    end

    # DELETE /resource/sign_out
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
      yield if block_given?
      respond_to_on_destroy
    end
  end
end
