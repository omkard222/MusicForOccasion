# helper file to make sure page is fully loaded
module CapybaraDriverHelpers
  def wait_for_traffic_to_finish
    still_working = true
    while still_working
      sleep 0.1
      still_working = page.driver.network_traffic.map(
        &:response_parts).any?(&:empty?)
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraDriverHelpers, type: :feature
end
