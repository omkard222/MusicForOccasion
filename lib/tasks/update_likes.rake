desc 'Update all likes amounts of facebook-connected and youtube-connected profiles'
task update_likes: :environment do
  connected_profiles = Profile.where.not(facebook_page_id: nil, facebook_token: nil)
  connected_profiles.find_each do |profile|
    likes = FacebookLikesLoader.get_likes_for profile
    profile.update facebook_page_likes: likes
  end
  profiles_with_youtube = Profile.where.not(youtube_channel_id: nil)
  profiles_with_youtube.find_each do |profile|
    RecalculateYoutubeSubscribers.youtube_count(profile)
  end
end
