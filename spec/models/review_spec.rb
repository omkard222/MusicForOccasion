require 'rails_helper'

describe Review do
  it { should belong_to :profile }
end