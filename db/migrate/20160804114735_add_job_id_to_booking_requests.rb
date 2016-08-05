class AddJobIdToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :job_id, :integer
  end
end
