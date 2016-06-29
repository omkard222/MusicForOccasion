module ProfilesHelper

  def profile_categories
    categories = ['Solo', 'Band', 'DJ'].map {|c| [c, c]}
    categories.first << {checked: true}
    categories
  end

  def profile_genres
    Genre.pluck(:name, :id).each {|pair| pair << {selected: true} if @profile.genre_ids.include?(pair[1]) }
  end

  def profile_instruments
    Instrument.pluck(:name, :id).each {|pair| pair << {selected: true} if @profile.instrument_ids.include?(pair[1]) }
  end

  def check_popularity_is_zero(profile)
    profile.calculate_popularity.zero? && profile.average_reviews.zero?
  end

  def get_classes(profile)
    if check_popularity_is_zero(profile)
      'ellipsis l_height' 
    else
      'ellipsis p_left'
    end
  end

  def distance_from(search_term)
   "#{profile.distance_from(search_term).round(2)} km"
  end

end