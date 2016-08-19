class Job < ActiveRecord::Base

  serialize :genre_ids, Array
  belongs_to :profile
  belongs_to :service_type
  has_many :booking_requests, dependent: :destroy
  after_initialize :initial_values
  enum event_type: [:bar_restaurant, :private_event, :club_lounge, :wedding, :corporate, :festival, :charity]
  enum booking_fee_type: [:send_inquiry, :free, :minimum_fees]
  enum free_fee_type:    [:for_fun, :for_charity_event]

  geocoded_by :location

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    obj.location = [geo.city, geo.state, geo.country].join(', ') if geo
  end

  after_validation :geocode

  def self.currencies
    {:AED=>{},:ARS=>{},:AUD=>{},:BGN=>{},:BRL=>{},
     :CAD=>{},:CHF=>{},:CNY=>{},:CRC=>{},:CZK=>{},
     :DKK=>{},:EUR=>{},:GBP=>{},:HKD=>{},:HRK=>{},
     :HUF=>{},:IDR=>{},:ILS=>{},:INR=>{},:JPY=>{},
     :KRW=>{},:MAD=>{},:MXN=>{},:MYR=>{},:NOK=>{},
     :NZD=>{},:PEN=>{},:PHP=>{},:PLN=>{},:RON=>{},
     :RUB=>{},:SEK=>{},:SGD=>{},:THB=>{},:TRY=>{},
     :TWD=>{},:UAH=>{},:USD=>{},:VND=>{},:ZAR=>{}}.keys
  end

  def available_date
    if service_type_id == 1
      "#{Date.parse(date_from.to_s).strftime("%d/%m/%Y")}"
    elsif service_type_id == 3
      "from #{Date.parse(date_from.to_s).strftime("%d/%m/%Y")} until #{Date.parse(date_to.to_s).strftime("%d/%m/%Y")}"
    else
      if is_saturday && is_sunday && !is_monday && !is_tuesday && !is_wednesday && !is_thursday && !is_friday
        "Weekends"
      elsif is_monday && is_tuesday && is_wednesday && is_thursday && is_friday && !is_saturday && !is_sunday
        "Weekdays"
      elsif is_monday && is_tuesday && is_wednesday && is_thursday && is_friday && is_saturday && is_sunday
        "Every day"
      else
        msg = ""
        msg = is_sunday ? msg + "Sunday, " : msg + ""
        msg = is_monday ? msg + "Monday, " : msg + ""
        msg = is_tuesday ? msg + "Tuesday, " : msg + ""
        msg = is_wednesday ? msg + "Wednesday, " : msg + ""
        msg = is_thursday ? msg + "Thursday, " : msg + ""
        msg = is_friday ? msg + "Friday, " : msg + ""
        msg = is_saturday ? msg + "Saturday, " : msg + ""
        return msg[0..-3]
      end
    end
  end

  def calendar_picker
    if service_type_id == 1
      return "1|#{ Date.parse(date_from.to_s).strftime("%Y/%m/%d") }|#{ Date.parse(date_from.to_s).strftime("%d/%m/%Y") }"
    elsif service_type_id == 2
      msg = ""
      msg = is_sunday ? msg + "T|" : msg + "F|"
      msg = is_monday ? msg + "T|" : msg + "F|"
      msg = is_tuesday ? msg + "T|" : msg + "F|"
      msg = is_wednesday ? msg + "T|" : msg + "F|"
      msg = is_thursday ? msg + "T|" : msg + "F|"
      msg = is_friday ? msg + "T|" : msg + "F|"
      msg = is_saturday ? msg + "T" : msg + "F"
      return "2|"+msg
    elsif service_type_id == 3
      return "3|#{ Date.parse(date_from.to_s).strftime("%Y/%m/%d") }|#{ Date.parse(date_to.to_s).strftime("%Y/%m/%d") }"
    end
  end
  
  private
  
  def initial_values
    self.minimum_fb_likes ||= 0
  end

  def event_type_enum
    Job.event_types.map { |key, val| [I18n.t("services.form.booking_fee_types.#{key}"), key] }
  end

  def booking_fee_type_enum
    Job.booking_fee_types.map { |key, val| [I18n.t("jobs.form.booking_fee_types.#{key}"), key] }
  end

  def free_fee_type_enum
    Job.free_fee_types.map { |key, val| [I18n.t("jobs.free_fee_types_2.#{key}"), key] }
  end
  
end
