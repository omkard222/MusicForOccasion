class AddUpdatedByToBookingRequest < ActiveRecord::Migration
  def change
    add_column :booking_requests, :updated_by_id, :integer
  end
  add_foreign_key :booking_requests, :users
end
