# Service model proposed by user
class Service < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :profile

  has_many :booking_requests, dependent: :destroy
  belongs_to :service_type
  alias_attribute :name, :headline

  validates :currency, inclusion: { in: BookingRequest::POSSIBLE_CURRENCIES }, if: -> { minimum_fees? }
  validates_presence_of :minutes_count, if: -> { minimum_fees? && per_minute? }

  enum booking_fee_type: [:send_inquiry, :free, :minimum_fees]
  enum free_fee_type:    [:for_fun, :for_charity_event]
  enum accommodation:    [:no_need, :any_types, :min_3, :min_4, :min_5]
  enum fee_time_type:    [:per_minute, :per_hour]

  def self.default_service
    free.where(free_fee_type: 'for_fun').first || minimum_fees.order(booking_fee: :asc).first || free.first || send_inquiry.first
  end

  def self.all_currencies(hash)
    hash.keys
  end

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

  def self.near(search_term, radius = ENV['DEFAULT_LOCATION_RADIUS'])
    profiles = Profile.near(search_term,
                            radius,
                            order: 'distance')

    profiles.map(&:services).flatten
  end

  def self.lastest_id
    return Service.last.id
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

  def title
    if description.to_s.length > 0
      return description
    else
      return headline
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

  def expired?
    if service_type_id == 1
      date_from < Date.today
    elsif service_type_id == 2
      false
    elsif service_type_id == 3
      date_to < Date.today
    end
  end

  def have_fee?
    return booking_fee.nil?
  end

  def user
    profile.present? ? profile.user : User.find(user_id)
  end

  def booking_fee_type_enum
    Service.booking_fee_types.map { |key, val| [I18n.t("services.form.booking_fee_types.#{key}"), key] }
  end

  def free_fee_type_enum
    Service.free_fee_types.map { |key, val| [I18n.t("services.free_fee_types_2.#{key}"), key] }
  end

  def accommodation_enum
    Service.accommodations.map { |key, val| [I18n.t("services.form.accommodations.#{key}"), key] }
  end

  def fee_time_type_enum
    Service.fee_time_types.map { |key, val| [I18n.t("services.form.fee_time_types_2.#{key}"), key] }
  end
end
