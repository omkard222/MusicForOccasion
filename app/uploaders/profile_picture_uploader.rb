# encoding: utf-8
# uploader for profile picture
class ProfilePictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage Rails.env.production? ? :fog : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    cls = "#{model.class.to_s.underscore}"
    "uploads/#{Rails.env}/#{cls}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('musicians/02.png')
  end

  version :thumb do
    process resize_to_fill: [280, 235]
  end

  version :services_display do
    process resize_to_fill: [32, 32]
  end
end
