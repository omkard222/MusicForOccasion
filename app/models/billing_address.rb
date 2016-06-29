# model for billing address for payment
class BillingAddress < ActiveRecord::Base
  acts_as_paranoid
  validates_numericality_of :post_code, integer_only: true
  belongs_to :user
end
