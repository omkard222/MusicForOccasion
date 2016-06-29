# encoding: utf-8
# uploader for profile Tech Rider (pdf)
class PDFUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage Rails.env.production? ? :fog : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    cls = "#{model.class.to_s.underscore}"
    "uploads/#{Rails.env}/#{cls}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
     %w(pdf)
  end
end
