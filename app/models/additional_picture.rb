# additionaly picture model belongs to profile
class AdditionalPicture < ActiveRecord::Base
  belongs_to :profile
  mount_uploader :image, AdditionalPicturesUploader
end
