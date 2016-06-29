module FacebookLikesLoader extend self
  def get_likes_for(profile, page_id = nil)
    return if profile.blank?

    page_id ||= profile.facebook_page_id.to_s
    token = profile.facebook_token.to_s

    return if page_id.blank? || token.blank?

    url = "https://graph.facebook.com/#{page_id}?fields=likes,name&access_token=#{token}"
    fb_info_json = JSON.parse(open(url).read)
    fb_info_json['likes']
  rescue OpenURI::HTTPError => e
    meta = e.io.metas
    if meta['www-authenticate'].first.try :include?, 'invalid_token'
      data = {profile: profile.id,
              token:   token,
              page_id: page_id}

      Rails.logger.warn "Invalid facebook token. #{data}"
      profile.disconnect_facebook!
      return nil
    end

    Rollbar.error e, url: url, io_metas: meta
    Rails.logger.warn e.inspect
    Rails.logger.warn meta
    Rails.logger.warn e.backtrace.select {|t| t.match(Rails.root.to_s) }.join("\n")
    return nil
  end
end
