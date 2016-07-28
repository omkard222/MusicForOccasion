class Job < ActiveRecord::Base

  serialize :genre_ids, Array
  belongs_to :profile
  
  after_initialize :initial_values
  
  private
  
  def initial_values
    self.minimum_fb_likes ||= 0
  end
  
end
