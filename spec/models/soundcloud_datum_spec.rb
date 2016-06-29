require 'rails_helper'

describe SoundcloudDatum do

  describe 'refresh token' do

    let(:user) { create(:valid_user) }
    let(:profile) { create(:profile, user: user) }
    let(:soundcloud_datum) { create(:soundcloud_datum, profile: profile, token_expires_at: 1.seconds.from_now) }
		
    let(:refresh_token_data) {
      { access_token: '1-182423-209423212-e14862fbff696', 
        expires_in: 21599, 
        scope: '*', 
        refresh_token: 'aea68e89b99e3e148c6367dc2acbc00b' }
      }

    before :each do
      soundcloud_datum
      stub_request(:post, 'https://api.soundcloud.com/oauth2/token').
      to_return(status: 200, body: refresh_token_data.to_json,
                headers: { 'Content-Type' => 'application/json; charset=utf-8' })
      sleep 1
    end

    it 'checks delayed job performance' do
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
      soundcloud_datum.reload
      expect(soundcloud_datum.access_token).to eq(refresh_token_data[:access_token])
      expect(soundcloud_datum.refresh_token).to eq(refresh_token_data[:refresh_token])
    end

    it 'checks delayed job performance after update' do
      soundcloud_datum.update(access_token: '123', refresh_token: '321', token_expires_at: 5.minutes.from_now + 1.seconds)
      sleep 1
      expect(Delayed::Worker.new.work_off).to eq([2, 0])
      soundcloud_datum.reload
      expect(soundcloud_datum.access_token).to eq(refresh_token_data[:access_token])
      expect(soundcloud_datum.refresh_token).to eq(refresh_token_data[:refresh_token])
    end    	

    it 'checks delayed job does not perform after update' do
      soundcloud_datum.update(access_token: '123', token_expires_at: 5.minutes.from_now + 1.seconds)
      sleep 1
      expect(Delayed::Worker.new.work_off).to eq([1, 0])
    end  	

  end

end  
