# Service model proposed by user
class ServiceType < ActiveRecord::Base
  has_one :service
  has_one :job

  def self.all_service_types
    ServiceType.order(:id).all.collect {|i| [ i.name, i.id ] }
  end

end
