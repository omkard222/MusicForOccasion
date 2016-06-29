require 'rails_helper'

describe MusicianGenre do
  it { should belong_to :profile }
  it { should belong_to :genre }
end