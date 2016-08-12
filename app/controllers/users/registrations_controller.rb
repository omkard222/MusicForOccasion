module Users
  # Customized to accept extra fileds.
  class RegistrationsController < Devise::RegistrationsController
    include ApplicationHelper
    before_filter :permit_devise_parameters

    def new
      @no_menu = true
      params_is_musician
      build_resource({})
      set_minimum_password_length
      yield resource if block_given?
      respond_with self.resource
    end

    def create
      @no_menu = true
      build_resource(sign_up_params)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          if session[:is_musician]
            set_flash_message :success, :musician_signed_up_success if is_flashing_format?
            redirect_to new_profile_path(type: :musician)
          else
            username = "#{resource.first_name} #{resource.last_name}"
            resource.profiles.create(profile_type: :registered_user,
                                     location: params[:user][:profile][:location],
                                     username: username,
                                     stage_name: username,
                                     sub_type: :default)

            set_flash_message :success, :signed_up_success if is_flashing_format?
            session[:is_musician] = nil
            if session[:try_book]
              profile_id = session[:try_book]
              session[:try_book] = nil
             # redirect_to profile_type_profiles_path(type: 'registered_user', edit: false) 
              redirect_to profile_path(profile_id)
            else
              redirect_to root_path
            end
          end
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        params_is_musician
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    def payment_method
      current_user.build_billing_address unless current_user.billing_address
      render 'payment_method', layout: false
    end

    def payment_method_update
      if current_user.update_attributes(first_name: params[:user][:first_name],last_name: params[:user][:last_name])
        if current_user.billing_address
          update_payment_method_details
        else
          create_bank_account_details
        end
      end
      redirect_to edit_user_registration_path
    end

    def update_payment_method_details
      if current_user.billing_address.update_attributes(
        payment_method_params['billing_address_attributes'])
        flash[:success] = 'Successfully update account details.'
      else
        flash[:error] = 'Invalid Postcode. Please try again.'
      end
    end

    def create_bank_account_details
      if current_user.create_billing_address(
        payment_method_params['billing_address_attributes'])
        flash[:success] = 'Successfully update account details.'
      else
        flash[:error] = 'Invalid Postcode. Please try again.'
      end
    end

    def receiving_money
      current_user.build_bank_account unless current_user.bank_account
      render 'receiving_money', layout: false
    end

    def receiving_money_update
      if current_user.bank_account
        update_receiving_money_details(receiving_money_params)
      else
        create_bank_account(receiving_money_params)
      end
      redirect_to edit_user_registration_path
    end

    def update_receiving_money_details(params)
      if current_user.bank_account.update_attributes(params)
        flash[:success] = 'Successfully update account details.'
      else
        flash[:error] = 'All field must be filled in.'
      end
    end

    def create_bank_account(params)
      if current_user.create_bank_account(params)
        flash[:success] = 'Successfully update account details.'
      else
        flash[:error] = 'All field must be filled in.'
      end
    end

    def store_payment_token
      current_user.update_attributes(stripe_token: params[:stripe_token])
      render nothing: true
    end

    def update
      resource.skip_reconfirmation!
      update_resource(resource, account_update_params)
    end

    def update_resource(resource, params)
      if params[:password].blank?
        params.delete('password')
        params.delete('password_confirmation')
      end
      if resource.update_attributes(params)
        sign_in resource, :bypass => true
        flash[:notice] = "Your login data has been updated successfully."
      else
        flash[:error] = resource.errors.full_messages.first if resource.errors.count > 0
      end
      redirect_to :back
    end

    def notifications
    end

    def set_notifications
      if current_user.update_attributes(notification_params)
        flash[:notice] = "Email notifications have been updated successfully."
      else
        flash[:error] = resource.errors.full_messages.first if resource.errors.count > 0
      end
      redirect_to :back
    end

    def user_profile

    end

    def update_user_profile
      if current_user.update_attributes(personal_params)
        flash[:notice] = "Your personal informations have been updated successfully."
      else
        flash[:error] = resource.errors.full_messages.first if resource.errors.count > 0
      end
      redirect_to :back
    end

    def delete_account
      booking_lists = BookingRequest.booking_list(current_profile.id)
      booking_lists.update_expired
      count_booking_lists = booking_lists.select { |booking| booking.status != 'Expired' && booking.status != 'Cancelled' && booking.status != 'Rejected'}.count
      request_lists = BookingRequest.request_list(current_profile.id)
      request_lists.update_expired
      count_request_list = request_lists.select { |booking| booking.status != 'Expired' && booking.status != 'Cancelled' && booking.status != 'Rejected'}.count
      @able_delete_account = (count_booking_lists == 0 && count_request_list == 0)
    end

    def destroy
      current_admin_or_profile.mailbox.receipts.destroy_all
      current_user.soft_delete
      AdminMessageMailer.delete_account(current_user.display_name,
                                        current_user.email,
                                        params[:reason],
                                        current_user.deleted_at.strftime("%d/%m/%Y %H:%M")).deliver_later
      Devise.sign_out_all_scopes ? sign_out : sign_out(current_user)
      flash[:notice] = "Your account has been successfully deleted."
      redirect_to new_user_session_path
    end

    private

    def params_is_musician
      @params_is_musician = session[:is_musician] ? true : false ;
    end

    def receiving_money_params
      params.require(:bank_account).permit(:name,
                                           :acc_number,
                                           :bank_name)
    end

    def stripe_token_param
      params.require(:user).permit(:stripe_token)
    end

    def payment_method_params
      params.require(:user).permit(:first_name,:last_name,
                                   billing_address_attributes: [:id,
                                                                :address1,
                                                                :address2,
                                                                :post_code,
                                                                :city,
                                                                :country])
    end

    def notification_params
      params.require(:user).permit(:notify_create_offer,
                                   :notify_create_booking,
                                   :notify_accept_booking,
                                   :notify_reject_booking,
                                   :notify_create_special_offer,
                                   :notify_cancel_booking,
                                   :notify_cancel_confirmed_booking,
                                   :notify_receive_message)
    end

    def personal_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :avatar)
    end

  end
end
