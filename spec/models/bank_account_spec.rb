require 'rails_helper'

describe BankAccount do
  it { should belong_to :profile }
end
