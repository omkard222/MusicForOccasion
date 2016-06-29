class RecalculateYoutubeSubscribers
  def self.youtube_count(profile)
    channel_id = profile.youtube_channel_id
    url_with_channel = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=#{channel_id}&key=" + ENV["GOOGLE_CLIENT_KEY"]
    url_with_channel_read = JSON.parse(open(url_with_channel).read)
    subscribers_count = url_with_channel_read['items'][0]['statistics']['subscriberCount']
    profile.update(youtube_subscribers: subscribers_count)
  end
end
