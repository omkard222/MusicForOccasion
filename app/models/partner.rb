class Partner < ActiveRecord::Base

	mount_uploader :partner_picture, PartnerPictureUploader
end
