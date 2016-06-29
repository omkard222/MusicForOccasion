class AddServiceProposerIdToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :service_proposer_id, :integer, references: :users
  end
end
