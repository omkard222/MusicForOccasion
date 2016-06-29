# bank account for receiving payment
class BankAccount < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :profile
end
