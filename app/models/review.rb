class Review < ActiveRecord::Base
  belongs_to :reviewer, class_name: 'Profile'
  belongs_to :profile

end
