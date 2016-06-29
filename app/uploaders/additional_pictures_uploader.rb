# encoding: utf-8
# uploader for additional pictures
class AdditionalPicturesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage Rails.env.production? ? :fog : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    cls = "#{model.class.to_s.underscore}"
    "uploads/#{Rails.env}/#{cls}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [280, 280]
  end
end
