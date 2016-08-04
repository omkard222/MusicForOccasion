module JobsHelper 
  def translated_event_type_options
    Job.event_types.keys.map { |type| [t("jobs.form.event_types.#{type}"), type] }
  end
  
end