module JobsHelper 
  def translated_event_type_options
    Job.event_types.keys.map { |type| [t("jobs.form.event_types.#{type}"), type] }
  end
  
  def translated_job_fee_type_options
    Job.booking_fee_types.keys.map { |type| [t("jobs.form.booking_fee_types.#{type}"), type] }
  end

  def job_fee_or_free(job, number_class=nil)
    return t("jobs.free_fee_types_2.#{job.free_fee_type}") if job.free?

    if job.minimum_fees? && job.booking_fee.present?
      "#{preferred_currency_session.upcase} <span class='#{number_class}'>#{convert_to_preferred_currency(job.currency, job.booking_fee)}</span>".html_safe
   	end
  end

  def job_genres
    Genre.pluck(:name, :id).each {|pair| pair << {selected: true} if @job.genre_ids.include?(pair[1]) }
  end 
end