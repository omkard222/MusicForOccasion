require 'rails_helper'

describe Admin do
  it { should validate_presence_of(:email).on(:create) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_uniqueness_of(:email).case_insensitive.allow_blank }
  it { should validate_length_of(:password) }
  it { should validate_confirmation_of :password }

  let(:admin) {build(:admin) }
  it '#role_enum' do
    expect(admin.role_enum).to eq([['Master Admin'], ['Admin']])
  end

  it '#mailboxer_email' do
    admin.email = 'test@mail.com'
    expect(admin.mailboxer_email(Object.new)).to eq(admin.email)
  end
end
