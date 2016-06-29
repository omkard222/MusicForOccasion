class App < Configurable
  config.soundcloud = {
    id: ENV['SOUNDCLOUD_ID'],
    secret: ENV['SOUNDCLOUD_SECRET'],
    return_url: ENV['SOUNDCLOUD_RETURN_URL']
  }
  config.version = '1.1.0'
end
