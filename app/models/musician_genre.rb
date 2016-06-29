# Musician model belongs to profile
class MusicianGenre < ActiveRecord::Base
  belongs_to :profile
  belongs_to :genre
end
