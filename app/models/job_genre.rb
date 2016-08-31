class JobGenre < ActiveRecord::Base
  belongs_to :job
  belongs_to :genre
end
