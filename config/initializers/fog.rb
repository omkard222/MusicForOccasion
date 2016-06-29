CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.aws_access_key_id,
      :aws_secret_access_key  => Rails.application.secrets.aws_secret_access_key,
      region: ENV['S3_REGION']
    }
    config.fog_directory  = ENV['S3_BUCKET'] || 'gigbazaar'
    config.fog_public     = false
  else
    config.storage = :file
    config.enable_processing = true
  end
end
