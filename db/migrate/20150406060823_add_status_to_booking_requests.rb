class AddStatusToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :status, :string
  end
end
