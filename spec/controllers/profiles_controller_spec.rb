require 'rails_helper'

describe ProfilesController, type: :controller do
  login_user

  let(:user) { User.last }
  let(:profile) { user.profiles.first }

  describe 'destroy' do

    it 'checks user impossibility to delete his last profile' do
      expect { delete :destroy, id: user.current_profile.id }.to_not change(Profile, :count)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Unable to delete profile.')
      expect(response).to redirect_to profile_delete_profile_path(user.current_profile.id)
    end

    it 'checks user impossibility to delete his last profile' do
      new_profile = FactoryGirl.create(:profile, user: user)
      user.set_current_profile(new_profile.id)
      expect { delete :destroy, id: user.current_profile.id }.to change(Profile, :count).from(2).to(1)
      expect(flash[:success]).to be_present
      expect(flash[:success]).to eq("You have successfully delete your profile #{new_profile.stage_name}.")
      expect(response).to redirect_to root_path
    end

  end

  describe 'soundcloud' do

    context '#soundcloud_request' do

      it 'checks redirection to soundcloud authentication' do
        get :soundcloud_request
        expect(response.location).to include('https://soundcloud.com/connect?')
      end

      it 'user will not be redirected if he have soundcloud data' do
        create(:soundcloud_datum, profile: profile)
        get :soundcloud_request
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('You current profile already assigned with a soundcloud account')
        expect(response).to redirect_to edit_profile_path(profile.id)
      end

    end

    context '#soundcloud' do

      let(:soundcloud_params) {
        {
          code: '703e4b925e2f7468078b072af4a5442a'
        }
      }

      describe 'create soundcloud data' do

        it 'checks soundcloud data creation' do
      	  expect_any_instance_of(Profile).to receive(:process_soundcloud_authorization_response).and_return(true)
          get :soundcloud, soundcloud_params
          expect(flash[:success]).to be_present
          expect(flash[:success]).to eq('Soundcloud account assigned with success')
          expect(response).to redirect_to edit_profile_path(profile.id)
        end

      end

      describe 'do not create soundcloud data' do
        let(:profile_new) {create(:profile, user: user)}

        let(:soundcloud_datum) { create(:soundcloud_datum, access_token: '1-182423-209423212-e14862fbff696',
                                        refresh_token: 'fea68e89b99e3e148c6367dc2acbc00c',
                                        client_id: '209423212',
                                        profile: profile_new) }


        it 'checks soundcloud was not created when if profile with sthis soundcloud data present' do
      	  expect_any_instance_of(Profile).to receive(:process_soundcloud_authorization_response).and_raise(ActiveRecord::RecordInvalid.new(soundcloud_datum))
          expect { get :soundcloud, soundcloud_params }.to_not change(SoundcloudDatum, :count)
          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq('This soundcloud account alredy assigned with other profile')
          expect(response).to redirect_to edit_profile_path(profile.id)
        end

        it 'checks soundcloud was not created when if profile have soundloud data' do
          soundcloud_datum.update_column(:profile_id, profile.id)
          expect { get :soundcloud, soundcloud_params }.to_not change(SoundcloudDatum, :count)
          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq('You current profile already assigned with a soundcloud account')
          expect(response).to redirect_to edit_profile_path(profile.id)
        end

      end

    end

  end

  describe 'paypal' do

    context '#paypal_confirm' do

      let (:paypal_confirm_params) { { email: 'test@test.com' } }

      it 'checks paypal confirmation changes' do
        post :paypal_confirm, paypal_confirm_params
        expect(profile.paypal_confirmation_sent?).to eq(true)
        expect(profile.paypal_account_email).to eq('test@test.com')
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Confirmation email for Paypal account successfully sent. Please check your inbox and follow the instructions received.')
        expect(response).to redirect_to edit_profile_path(profile.id)
      end

      it 'checks paypal confirmation changes did not save' do
        expect_any_instance_of(Profile).to receive(:send_paypal_confirmation).and_raise(ActiveRecord::RecordInvalid)
        post :paypal_confirm, paypal_confirm_params
        expect(profile.paypal_confirmation_sent?).to eq(false)
        expect(profile.paypal_account_email).to eq(nil)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Failed to send confirmation message')
        expect(response).to redirect_to edit_profile_path(profile.id)
      end

    end

    context '#paypal_confirmation' do

      let(:token) { '123' }

      before (:each) do
        profile.update(paypal_account_email_confirmation_status: 1, paypal_account_email_confirmation_token: token)
      end

      it 'checks paypal confirmation' do
        get :paypal_confirmation, profile_id: profile.id, token: token
        profile.reload
        expect(profile.paypal_confirmed?).to eq(true)
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Successfully connected your Paypal account with your profile')
        expect(response).to redirect_to root_path
      end

      it 'checks paypal confirmation was not performed because of exception' do
        expect_any_instance_of(Profile).to receive(:paypal_confirm).and_raise(ActiveRecord::RecordInvalid)        
        get :paypal_confirmation, profile_id: profile.id, token: token
        profile.reload
        expect(profile.paypal_confirmed?).to eq(false)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Failed to confirm PayPal email')
        expect(response).to redirect_to root_path
      end

      it 'checks paypal confirmation was not performed because of confirmation was reset' do
        profile.paypal_unconfirmed!      
        get :paypal_confirmation, profile_id: profile.id, token: token
        profile.reload
        expect(profile.paypal_confirmed?).to eq(false)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('PayPal email confirmation is reset')
        expect(response).to redirect_to root_path
      end

      it 'checks paypal confirmation was not performed because of confirmation was reset' do
        profile.paypal_confirmed!      
        get :paypal_confirmation, profile_id: profile.id, token: token
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('PayPal email is already confirmed')
        expect(response).to redirect_to root_path
      end

      it 'checks paypal confirmation was not performed because of confirmation was reset' do
        get :paypal_confirmation, profile_id: profile.id, token: 'token'
        profile.reload
        expect(profile.paypal_confirmed?).to eq(false)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Wrong confirmation token')
        expect(response).to redirect_to root_path
      end

    end

    context '#paypal_remove_confirmation' do

      before (:each) do
        profile.paypal_confirmed!
      end

      it 'checks paypal confirmation' do
        post :paypal_remove_confirmation
        profile.reload
        expect(profile.paypal_unconfirmed?).to eq(true)
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Successfully removed your Paypal email')
        expect(response).to redirect_to edit_profile_path(profile.id)
      end

      it 'checks paypal confirmation was not performed because of exception' do
        expect_any_instance_of(Profile).to receive(:update).and_raise(ActiveRecord::RecordInvalid)        
        post :paypal_remove_confirmation
        profile.reload
        expect(profile.paypal_unconfirmed?).to eq(false)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Failed to remove PayPal email confirmation')
        expect(response).to redirect_to edit_profile_path(profile.id)
      end

    end

  end

end
