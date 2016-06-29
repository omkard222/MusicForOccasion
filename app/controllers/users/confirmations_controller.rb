module Users
  # Customized to accept extra fileds.
  class ConfirmationsController < Devise::ConfirmationsController
    include ApplicationHelper
    before_filter :permit_devise_parameters
    # GET /users/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message(:notice, :confirmed) if is_flashing_format?
        sign_in(resource)

        return respond_with_navigational(resource){ redirect_to new_profile_path(type: :musician) } unless resource.current_profile

        if resource.is_musician?
          respond_with_navigational(resource){ redirect_to profile_path(resource.current_profile.id) }
        else
          respond_with_navigational(resource){ redirect_to root_path }
        end
      else
        user = User.find_by_confirmation_token(params[:confirmation_token])
        if user
          if user.deleted_at
            set_flash_message(:error, :must_sign_up)
            redirect_to new_user_session_path
          else
            set_flash_message(:error, :must_sign_in)
            redirect_to new_user_session_path
          end
        else
          set_flash_message(:error, :invalid_link)
          redirect_to root_path
        end
      end
    end

  end
end
