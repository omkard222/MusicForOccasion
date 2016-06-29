Admin.delete_all
Genre.delete_all
Instrument.delete_all
Profile.delete_all
Service.delete_all
User.delete_all
MusicianGenre.delete_all
ServiceType.delete_all

# admin = Admin.create!(email: ENV['MASTER_ADMIN_EMAIL'],
#                      password: ENV['MASTER_ADMIN_PASSWORD'],
#                      role: 'Master Admin')
admin = Admin.create!(email: 'admin@gmail.com',
                     password: 'enbake123',
                     role: 'Master Admin')
puts ">>>>> - Admin #{admin.email} has been created"

['Alternative', 'Blues', 'Classical Music', 'Country Music', 'Dance Music',
 'Dance Music', 'Easy Listening', 'Electronic Music', 'European Music',
 'Hip Hop/Rap', 'Hip Hop/Rap', 'Indie Pop', 'Inspirational', 'Asian Pop',
 'Jazz', 'Latin Music', 'Latin Music', 'New Age', 'Opera', 'Pop', 'R&B/Soul',
 'Reggae', 'Rock', 'Singer/Songwriter', 'World Music/Beats'].each do |name|
   Genre.create!(name: name)
end
puts '>>>>> - Genre has been created.'

['Accordion', 'Acoustic Guitar', 'Bagpipes', 'Bass Guitar', 'Cello', 'Clarinet',
 'Drums', 'Electric Guitar', 'Flute', 'Guitar', 'Harmonica', 'Keyboards',
 'Piano', 'Saxophone', 'Synthesizer', 'Trumpet', 'Ukulele', 'Violin',
 'Xylophone'].each do |name|
   Instrument.create!(name: name)
end
puts '>>>>> - Instrument has been created.'

#create musician user
user1 = User.create!(first_name: 'Johny', last_name: 'Dave', email: 'Johny@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user2 = User.create!(first_name: 'Michel', last_name: 'Maren', email: 'Michel@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user3 = User.create!(first_name: 'Thipawan', last_name: 'Boon', email: 'moji2328@hotmail.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user4 = User.create!(first_name: 'Jirapong', last_name: 'Nanta', email: 'jirapong@msn.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user5 = User.create!(first_name: 'Nam', last_name: 'Gustsnova', email: 'Nam@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user6 = User.create!(first_name: 'Tan', last_name: 'Camp', email: 'Tan@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user7 = User.create!(first_name: 'Jenny', last_name: 'Kim', email: 'Jenny@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user8 = User.create!(first_name: 'Loy', last_name: 'Mirrow', email: 'Loy@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user9 = User.create!(first_name: 'Somsee', last_name: 'Lee', email: 'Somsee@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user10 = User.create!(first_name: 'Boon', last_name: 'Asai', email: 'Boon@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user11 = User.create!(first_name: 'Jon', last_name: 'Liddell', email: 'Jon@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user12 = User.create!(first_name: 'DE', last_name: 'FAM', email: 'Defam@gigbazaar.com', password: '12341234 ', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user13 = User.create!(first_name: 'Talitha', last_name: 'Tan', email: 'Talitha@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user14 = User.create!(first_name: 'Musician', last_name: 'User', email: 'music@email.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user15 = User.create!(first_name: 'iTOP', last_name: 'RuKC', email: 'user@email.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')

#create visitor user
user16 = User.create!(first_name: 'Good', last_name: 'View', email: 'Good@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user17 = User.create!(first_name: 'Gust', last_name: 'Jung', email: 'Gust@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user18 = User.create!(first_name: 'Wild', last_name: 'Mile', email: 'Wild@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user19 = User.create!(first_name: 'Spao', last_name: 'Kum', email: 'Spao@gigbazaar.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')
user20 = User.create!(first_name: 'Visitor', last_name: 'User', email: 'visit@email.com', password: '12341234', confirmed_at: '2015-07-13', confirmation_sent_at: '2015-07-13')

#create profile of musician
bio_info = "Music is an art form whose medium is sound and silence. Generally, a song is considered the smallest standalone work of music, especially when involving singing. The common elements of music are pitch (which governs melody and harmony), rhythm (and its associated concepts tempo, meter, and articulation), dynamics, and the sonic qualities of timbre and texture. The word derives from Greek μουσική (mousike; \"art of the Muses\").[1] In its most general form the activities describing music as an art form include the production of works of music, the criticism of music, the study of the history of music, and the aesthetic dissemination of music."
soundcloud_url = "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/36650065&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false\"></iframe>"
Profile.create!(user: user1, stage_name: 'Johny Dave', category: 'Solo',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Chiang Mai, Thailand', latitude: '18.787747',
                longitude: '98.99312839999999', profile_type: :musician)
Profile.create!(user: user2, stage_name: 'The End', category: 'Band',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Bangkok, Thailand', latitude: '13.7563309',
                longitude: '100.5017651', profile_type: :musician)
Profile.create!(user: user3, stage_name: 'Ducky', category: 'Solo',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Phuket, Thailand', latitude: '7.9519331',
                longitude: '98.33808839999999', profile_type: :musician)
Profile.create!(user: user4, stage_name: 'Like Noon', category: 'DJ',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Chiang Mai, Thailand', latitude: '18.787747',
                longitude: '98.99312839999999', profile_type: :musician)
Profile.create!(user: user5, stage_name: 'Jirapong Nanta', category: 'Solo',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Chiang Mai, Thailand', latitude: '18.787747',
                longitude: '98.99312839999999', profile_type: :musician)
Profile.create!(user: user6, stage_name: 'Peach Band', category: 'Band',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Chiang Rai, Thailand', latitude: '19.8892545',
                longitude: '99.82682760000002', profile_type: :musician)
Profile.create!(user: user7, stage_name: 'Jennyfer Kim', category: 'Solo',
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Bangkok, Thailand', latitude: '13.7563309',
                longitude: '100.5017651', profile_type: :musician)
Profile.create!(user: user8, stage_name: 'Pop', category: 'Band',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/sENM2wA_FTg\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Chiang Mai, Thailand',
                latitude: '18.787747', longitude: '98.99312839999999',
                profile_type: :musician)
Profile.create!(user: user9, stage_name: 'Boonchoo', category: 'Band',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/co4YpHTqmfQ\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Nan, Thailand',
                latitude: '18.7756318', longitude: '100.7730417',
                profile_type: :musician)
Profile.create!(user: user10, stage_name: 'Boon Asai', category: 'DJ',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/US9Cq1f54h4\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Bangkok, Thailand',
                latitude: '13.7563309', longitude: '100.5017651',
                profile_type: :musician)
Profile.create!(user: user11, stage_name: 'Jon Liddell', category: 'Solo',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/mWRsgZuwf_8\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Kuala Lumpur, Malaysia',
                latitude: '3.139882', longitude: '101.693768',
                profile_type: :musician)
Profile.create!(user: user12, stage_name: 'DE Fam', category: 'Band',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/-CmadmM5cOk\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Kuala Lumpur, Malaysia',
                latitude: '3.139882', longitude: '101.693768',
                profile_type: :musician)
Profile.create!(user: user13, stage_name: 'Talitha Tan', category: 'Solo',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ktvTqknDobU\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Kuala Lumpur, Malaysia',
                latitude: '3.139882', longitude: '101.693768',
                profile_type: :musician)
Profile.create!(user: user14, stage_name: 'Tasha Aleia', category: 'Solo',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ScNNfyq3d_w\" frameborder=\"0\" allowfullscreen></iframe>",
                biography: bio_info, location: 'Kuala Lumpur, Malaysia',
                latitude: '3.139882', longitude: '101.693768',
                profile_type: :musician)
Profile.create!(user: user15, stage_name: 'Da Da', category: 'Solo',
                youtube_url: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/uozAhIkHWhI\" frameborder=\"0\" allowfullscreen></iframe>",
                soundcloud_url: soundcloud_url, biography: bio_info,
                location: 'Chiang Mai, Thailand', latitude: '18.787747',
                longitude: '98.99312839999999', profile_type: :musician)

#create musician_genres
MusicianGenre.create!(profile_id: 1, genre_id: 1)
MusicianGenre.create!(profile_id: 1, genre_id: 3)
MusicianGenre.create!(profile_id: 2, genre_id: 1)
MusicianGenre.create!(profile_id: 2, genre_id: 2)
MusicianGenre.create!(profile_id: 2, genre_id: 3)
MusicianGenre.create!(profile_id: 3, genre_id: 1)
MusicianGenre.create!(profile_id: 3, genre_id: 2)
MusicianGenre.create!(profile_id: 3, genre_id: 3)
MusicianGenre.create!(profile_id: 4, genre_id: 1)
MusicianGenre.create!(profile_id: 4, genre_id: 2)
MusicianGenre.create!(profile_id: 4, genre_id: 3)
MusicianGenre.create!(profile_id: 5, genre_id: 1)
MusicianGenre.create!(profile_id: 5, genre_id: 3)
MusicianGenre.create!(profile_id: 6, genre_id: 1)
MusicianGenre.create!(profile_id: 7, genre_id: 1)
MusicianGenre.create!(profile_id: 8, genre_id: 1)
MusicianGenre.create!(profile_id: 8, genre_id: 2)
MusicianGenre.create!(profile_id: 8, genre_id: 3)
MusicianGenre.create!(profile_id: 9, genre_id: 1)
MusicianGenre.create!(profile_id: 9, genre_id: 2)
MusicianGenre.create!(profile_id: 9, genre_id: 3)
MusicianGenre.create!(profile_id: 10, genre_id: 1)
MusicianGenre.create!(profile_id: 10, genre_id: 3)
MusicianGenre.create!(profile_id: 11, genre_id: 2)
MusicianGenre.create!(profile_id: 11, genre_id: 3)
MusicianGenre.create!(profile_id: 12, genre_id: 2)
MusicianGenre.create!(profile_id: 12, genre_id: 3)
MusicianGenre.create!(profile_id: 13, genre_id: 3)
MusicianGenre.create!(profile_id: 13, genre_id: 4)
MusicianGenre.create!(profile_id: 14, genre_id: 1)
MusicianGenre.create!(profile_id: 14, genre_id: 3)
MusicianGenre.create!(profile_id: 15, genre_id: 4)

#create service for some musicians
Service.create!(profile: user1.current_profile, headline: 'Love song', description: 'Single day', booking_fee: '2000', currency: 'THB',
  service_type_id: '1', date_from: '2015-11-1')
Service.create!(profile: user2.current_profile, headline: 'Happy Song', description: 'Every sunday', booking_fee: '1500', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'false', is_wednesday: 'false', is_thursday: 'false', is_friday: 'false', is_saturday: 'true')
Service.create!(profile: user3.current_profile, headline: 'Music Live', description: 'Saturday-Sunday', booking_fee: '1000', currency: 'THB',
  service_type_id: '2', is_sunday: 'false', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'false', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user4.current_profile, headline: 'Music live in Bangkok', description: 'Everyday', booking_fee: '1200', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user5.current_profile, headline: 'Chiang Mai Lovely Song', description: 'Everyday', booking_fee: '1000', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'false', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user6.current_profile, headline: 'Chiang Rai Song', description: 'Every night', booking_fee: '3000', currency: 'THB',
  service_type_id: '2', is_sunday: 'false', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'false')
Service.create!(profile: user7.current_profile, headline: 'Music live in Bangkok', description: 'Everyday', booking_fee: '1200', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user8.current_profile, headline: 'Music live in Bangkok', description: 'Everyday', booking_fee: '1200', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user9.current_profile, headline: 'Music live in Nan', description: 'Weekends', booking_fee: '500', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'false', is_tuesday: 'false', is_wednesday: 'false', is_thursday: 'false', is_friday: 'false', is_saturday: 'true')
Service.create!(profile: user10.current_profile, headline: 'Music live in Bangkok', description: 'Everyday', booking_fee: '1200', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user11.current_profile, headline: 'Good song good music', description: 'Everyday', booking_fee: '4200', currency: 'USD',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user11.current_profile, headline: 'Music live in Bangkok', description: 'Everyday', booking_fee: '1200', currency: 'THB',
  service_type_id: '2', is_sunday: 'true', is_monday: 'true', is_tuesday: 'true', is_wednesday: 'true', is_thursday: 'true', is_friday: 'true', is_saturday: 'true')
Service.create!(profile: user12.current_profile, headline: 'Kuala Lumpur Music', description: 'Date range', booking_fee: '500', currency: 'USD',
  service_type_id: '3', date_from: '2015-12-1',date_to: 24.weeks.from_now)
Service.create!(profile: user13.current_profile, headline: 'Kuala Lumpur Music', description: 'Date range', booking_fee: '500', currency: 'USD',
  service_type_id: '3', date_from: '2015-11-1',date_to: 24.weeks.from_now)
Service.create!(profile: user14.current_profile, headline: 'Indy kids', description: 'Date range', booking_fee: '2500', currency: 'USD',
  service_type_id: '3', date_from: '2015-10-26',date_to: 24.weeks.from_now)
Service.create!(profile: user15.current_profile, headline: 'Cody Rusto', description: 'Date range', booking_fee: '199', currency: 'USD',
  service_type_id: '3', date_from: '2015-10-26',date_to: 24.weeks.from_now)

ServiceType.create(id: 1, name: 'Only this day')
ServiceType.create(id: 2, name: 'Every week on...')
ServiceType.create(id: 3, name: 'During this period of time')
puts ">>>>> - Service type has been created."

Profile.where(:slug => nil).each do |p|
  p.stage_name = "#{p.stage_name}_changed"
  p.save!
  p.stage_name = p.stage_name.gsub('_changed', '')
  p.save!
end
