# Admin model
class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  acts_as_messageable
  mount_uploader :profile_picture, ProfilePictureUploader
  alias_attribute :username, :name

  # customized devise validation
  validates_uniqueness_of :email,
                          case_sensitive: false,
                          allow_blank: true, if: :email_changed?
  validates_format_of :email,
                      with:  Devise.email_regexp,
                      allow_blank: true, if: :email_changed?
  validates_presence_of :email, on: :create
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create
  validates_length_of :password,
                      within: Devise.password_length,
                      allow_blank: true

  def role_enum
    [['Master Admin'], ['Admin']]
  end

  def mailboxer_email(_object)
    email
  end
end
