class Profile < ActiveRecord::Base
  acts_as_paranoid
  acts_as_messageable
  before_destroy { messages.destroy_all }

  belongs_to :user
  has_many :additional_pictures
  has_and_belongs_to_many :instruments
  has_many :musician_genres, dependent: :destroy
  has_many :genres, through: :musician_genres
  has_many :services, dependent: :destroy
  has_many :booking_requests, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :created_reviews, dependent: :destroy, foreign_key: 'reviewer_id', class_name: 'Review'

  has_one :soundcloud_datum, dependent: :destroy
  has_one :bank_account, dependent: :destroy
  has_many :profile_history, dependent: :destroy

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :additional_pictures
  accepts_nested_attributes_for :bank_account, allow_destroy: true

  validates_uniqueness_of :username, allow_nil: true, conditions: -> { where(deleted_at: nil) }
  validates_uniqueness_of :stage_name, allow_nil: true, case_sensitive: false, conditions: -> { where(deleted_at: nil) }
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: false, conditions: -> { where(deleted_at: nil) }

  validates_presence_of :username, if: -> { stage_name.blank? }
  validates_presence_of :stage_name, if: -> { username.blank? }

  mount_uploader :profile_picture, ProfilePictureUploader
  mount_uploader :tech_rider, PDFUploader
  mount_uploader :site_logo, SiteLogoUploader
  alias_attribute :name, :username
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :rotation_angle, 
  :zoom_w, :zoom_h, :zoom_x, :zoom_y, :drag_x, :drag_y
  #validate :site_logo_size_validation, unless: -> { site_logo.blank? }

  before_save :save_slug
  before_save :set_position_priority
  before_update :if_last_profile

  enum profile_type: [:registered_user, :musician]
  enum sub_type: [:private_events, :event_organizer, :venue, :corporate, :booking_agent]
  enum paypal_account_email_confirmation_status: [:paypal_unconfirmed, :paypal_confirmation_sent, :paypal_confirmed]

  scope :musician_has_services, -> { musician.joins(:services).where(services: { deleted_at: nil }).uniq }
  scope :current, -> { where(current: true).first }
  PICTURE_PRIORITY = 1000000
  geocoded_by :location

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    obj.location = [geo.city, geo.state, geo.country].join(', ') if geo
  end

  after_validation :geocode

  def email
    user.email
  end

  def average_reviews
    collect_reviews.average(:score).to_f
  end

  def pic_link_able?
    musician? && user.active_user
  end

  def first_genre
    musician_genres.first.try(:genre).try(:name)
  end

  def picture
    if musician?
      if profile_picture.present?
        profile_picture.thumb.url
      else
        'musicians/01.jpg'
      end
    else
      if profile_picture.present?
        profile_picture.thumb.url
      else
        avatar = user.avatar
        if avatar.present?
          avatar.thumb.url
        else
          'musicians/02.png'
        end
      end
    end
  end

  def youtube_embedded_code
    if youtube_url
      if youtube_url.include? "www.youtube.com/embed/"
        youtube_code = (youtube_url.split("embed/")[1]).split("\"")[0]
        if youtube_code.length != 11
          youtube_code = nil
        end
      elsif youtube_url.include? "youtu.be/"
        youtube_code = (youtube_url.split("youtu.be/")[1]).split("?")[0]
        if youtube_code.length != 11
          youtube_code = nil
        end
      elsif youtube_url.match(/\?.*v=/)
        youtube_code = (Rack::Utils.parse_query URI(youtube_url).query)["v"]
        if youtube_code.length != 11
          youtube_code = nil
        end
      elsif youtube_url.length == 11
        return youtube_url
      else
        youtube_code = nil
      end
    end
    return youtube_code
  end

  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end

  def set_profile_type(type)
    send("#{type}!".to_sym)
  end

  def save_slug
    if stage_name_changed? || stage_name.nil?
      self.slug = to_slug(username ||stage_name || user.email)
    end
  end

  def to_slug(string)
    pre_slug = string.gsub(/[^0-9A-Za-z]/, ' ').split.join('-').downcase
    duplicate_counter = Profile.where("slug LIKE '#{pre_slug}%'").count
    duplicate_counter > 0 ? pre_slug + "-#{duplicate_counter}" : pre_slug
  end

  def active_services
    services.where(deleted_at: nil)
  end

  def default_service
    active_services.default_service
  end

  def History
    stage_name  
  end

  def Migration
    stage_name
  end

  def virtual_name
    if stage_name.present? || username.present?
      profile_type == 'musician' ? stage_name : username
    else
      "No name"
    end
  end

  def virtual_name=(value)
    if profile_type == 'musician'
      self.stage_name = value
    else
      self.username = value
    end
  end

  def has_full_geo?
    location? && longitude? && latitude?
  end

  def if_last_profile
    if User.find(user_id_was).profiles.count <= 1 && user_id_was != user_id
      self.user_id = user_id_was
      self.errors.add(:base, I18n.t('.last_profile'))
      false
    end
  end

  def mailboxer_email(_)
    user.email
  end

  alias_method :display_name, :virtual_name

  def collect_reviews
    reviews.joins(:reviewer)
  end

  def process_soundcloud_authorization_response(code)
    client = SoundcloudDatum.soundcloud_client
    client.exchange_token(code: code)
    me = client.get('/me')
    create_soundcloud_datum!(access_token: client.access_token,
                             refresh_token: client.refresh_token,
                             client_id: me.id,
                             token_expires_at: client.expires_at)
  end

  def get_tracks_plays
    client = SoundcloudDatum.soundcloud_client(access_token: soundcloud_datum.access_token)
    client.get("/users/#{soundcloud_datum.client_id}/tracks").inject(0) { | count, track | count += track.playback_count }
  rescue Soundcloud::ResponseError => e
    soundcloud_datum.destroy if e.response.code == 401
    Rails.logger.info e.inspect
    Rails.logger.info e.backtrace.select {|t| t.match(Rails.root.to_s) }.join("\n")
    return nil
  end

  def get_soundcloud_user_info
    if soundcloud_datum
      client = SoundcloudDatum.soundcloud_client(access_token: soundcloud_datum.access_token)
      me = client.get('/me')
      { followers_count: me.followers_count, permalink: me.permalink }
    else
      {}
    end
  rescue Soundcloud::ResponseError
    Rails.logger.info $!.inspect
    Rails.logger.info $!.backtrace.select {|t| t.match(Rails.root.to_s) }.join("\n")
    return {}
  end

  def calculate_popularity
    popularity = facebook_page_likes.to_i.to_f
  end

  def rate_count
    get_review = collect_reviews
    reviews_comment = get_review.where.not(message: nil).order(:created_at)
    review_scores = get_review.where(profile_id: id, deleted_at: nil)
    rate_count = review_scores.where.not(score: nil)
  end

  def disconnect_facebook!
    update!(facebook_token:      nil,
            facebook_page_id:    nil,
            facebook_page_likes: nil)
  end

  def average_score
    reviews.average(:score)
  end

  def send_paypal_confirmation(email)
    Profile.transaction do
      token = Digest::MD5.hexdigest((Time.zone.now.to_i + rand(1..1000)).to_s)
      update(paypal_account_email: email,
             paypal_account_email_confirmation_status: 1,
             paypal_account_email_confirmation_token: token)
      ProfileMailer.paypal_confirmation(self).deliver_later
    end
  end

  def paypal_confirm
    update(paypal_account_email_confirmed_at: Time.zone.now, paypal_account_email_confirmation_status: 2)
  end

  def remove_confirmation
    update(paypal_account_email_confirmed_at: nil, paypal_account_email_confirmation_status: 0)
  end

  def set_position_priority
    picture_score = profile_picture.file.present? ? PICTURE_PRIORITY : 0
    self.position_priority = picture_score + facebook_page_likes.to_i
  end

  def site_logo_size_validation
    if site_logo.present?
      image = MiniMagick::Image.open(site_logo.path)
      if  image[:width] > 50 && image[:height] > 50
        errors.add(:base, "Image should of size 50x50")
      end
    end   
  end
end
