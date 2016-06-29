class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  include ApplicationHelper
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook,:twitter,:google_oauth2]

  acts_as_messageable
  acts_as_paranoid

  has_many :profiles, dependent: :destroy
  has_one :billing_address, dependent: :destroy
  accepts_nested_attributes_for :billing_address, allow_destroy: true
  has_many :services, through: :profiles
  validates :terms_and_policies, acceptance: true
  mount_uploader :avatar, ProfilePictureUploader

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def self.connections(auth)
    if User.where(email: auth.info.email).exists?
      return_user = User.where(email: auth.info.email).first
      return_user.provider = auth.provider
      return_user.uid = auth.uid
      return_user.save
    else
      return_user = User.create! do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.skip_confirmation!
      end
    end
    return_user
  end

  def current_profile
    @current_profile ||= profiles.where(current: true).first || last_profile || nocurrent_profile
  end

  def provider?
    provider
  end

  def mailboxer_email(_object)
    email
  end

  def send_system_notification(status, actor, booking)
    notify(status, actor, booking)
  end

  def active_for_authentication?
    super && active_user
  end

  def active_user
    !deleted_at && !banned
  end

  def pic_link_able
    is_musician? && active_user
  end

  def inactive_message
    banned ? 'This account has been suspended.' : super
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(value)
    self.first_name = value.split(' ')[0]
    self.last_name = value.split(' ')[1]
  end

  def display_name
    is_musician? ? current_profile.stage_name : name
  end

  def picture
    return current_profile.picture if current_profile

    avatar.present? ? avatar.thumb.url : 'musicians/02.png'
  end

  def soft_delete
    profiles.each(&:soft_delete)
    update_attribute(:deleted_at, Time.now)
  end

  def set_current_profile(profile_id)
    current_profile.update!(current: false) if current_profile
    profile = profiles.find(profile_id)
    profile.update!(current: true, become_current_at: Time.zone.now)
    @current_profile = profile
  end

  def is_musician?
    current_profile.musician? if current_profile
  end

  private

  def last_profile
    profiles.where('become_current_at is NOT NULL').order('become_current_at DESC').first
  end

  def nocurrent_profile
    profiles.first
  end

end
