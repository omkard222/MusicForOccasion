class AddDeletedAtToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :deleted_at, :datetime
    add_index :booking_requests, :deleted_at
  end
end
