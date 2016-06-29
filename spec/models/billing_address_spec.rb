require 'rails_helper'

describe BillingAddress do
  it { should belong_to :user }
  it { should validate_numericality_of :post_code }
end
