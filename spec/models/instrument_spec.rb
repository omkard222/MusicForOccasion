require 'rails_helper'

describe Instrument do
  it { should have_and_belong_to_many(:profiles) }
end
