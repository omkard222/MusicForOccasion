# encoding: utf-8
# uploader for profile picture
class ProfilePictureUploader < CarrierWave::Uploader::Base
   include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  #storage Rails.env.production? ? :fog : :file
  # storage Rails.env.production? ? :file : :file
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    cls = "#{model.class.to_s.underscore}"
    "uploads/#{Rails.env}/#{cls}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('musicians/02.png')
  end

  # version :thumb do
  #   process resize_to_fill: [280, 235]
  # end

  # version :services_display do
  #   process resize_to_fill: [32, 32]
  # end
  # version :large do
  #   resize_to_limit(600, 600)
  # end

  version :thumb do
     process :crop
    # resize_to_fill(100, 100)
  end
  
  def crop
    if model.crop_x.present?
      # resize_to_limit(600, 600)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end
end  