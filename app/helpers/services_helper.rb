module ServicesHelper 
  def translated_fee_type_options
    Service.booking_fee_types.keys.map { |type| [t("services.form.booking_fee_types.#{type}"), type] }
  end

  def service_fee_or_free(service, number_class=nil)
    return t("services.free_fee_types_2.#{service.free_fee_type}") if service.free?

    if service.minimum_fees? && service.booking_fee.present?
      "#{preferred_currency_session.upcase} <span class='#{number_class}'>#{convert_to_preferred_currency(service.currency, service.booking_fee)}#{ service.per_hour? ? ' / hour' : '' }</span>".html_safe
   	end
  end
  
end