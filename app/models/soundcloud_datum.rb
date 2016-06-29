class SoundcloudDatum < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :profile

  validates_uniqueness_of :client_id, case_sensitive: false, conditions: -> { where(deleted_at: nil) }

  after_save :check_refresh_token_change

  def check_refresh_token_change
    if access_token_changed? && refresh_token_changed? && token_expires_at_changed?
  	  delay(run_at: token_expires_at - 5.minutes).refresh_token_change
    end
  end

  def refresh_token_change
    @logger = Logger.new("#{Rails.root}/log/soundcloud_refresh_token_log.log", shift_age = 7, shift_size = 1048576) rescue nil
    @logger.warn '-'*100
    @logger.warn "Started at: #{Time.zone.now}"
    @logger.warn "Profile id: #{profile_id}"
    @logger.warn "Old access token: #{access_token}"
    @logger.warn "Old refresh token: #{refresh_token}"
    client = self.class.soundcloud_client(client_id: App.soundcloud[:id],
                               	          client_secret: App.soundcloud[:secret],
                                	        refresh_token: refresh_token)
    @logger.warn "New access token: #{client.access_token}"
    @logger.warn "New refresh token: #{client.refresh_token}"
    update(access_token: client.access_token,
    	     refresh_token: client.refresh_token,
    	     token_expires_at: client.expires_at)
  rescue
    @logger.warn 'Exeption occured during soundcloud token refresh'
    @logger.warn $!.message
    Rollbar.error($!)
  ensure
    @logger.warn '-'*100
  end

  def self.soundcloud_client(arguments = nil)
    cc = App.soundcloud[:id]
    raise cc.inspect
    arguments_final = arguments || { client_id: App.soundcloud[:id],
                                     client_secret: App.soundcloud[:secret],
                                     redirect_uri: App.soundcloud[:return_url] }
    Soundcloud.new(arguments_final)
  end

  def self.soundcloud_authorize_url
    @url ||= soundcloud_client.authorize_url()
  end

end
