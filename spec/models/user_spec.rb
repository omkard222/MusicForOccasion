require 'rails_helper'

describe User do
  before do
    @user = FactoryGirl.create(:valid_user)
  end

  subject { @user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :terms_and_policies }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_acceptance_of :terms_and_policies }

  it 'should filter confirmed user' do
    create_list :valid_user, 2
    user = create(:user, set_confirmed: false)
    expect(User.confirmed.all).not_to include(user)
    expect(User.confirmed.count).to eq(3)
  end

  context "set and get current profile" do

    let(:user) { create(:valid_user) }

    before(:each) do
      ['registered_user', 'musician', 'registered_user'].each_with_index do | type, i |
        create(:profile, username: "Name_#{i}", stage_name: "Name_#{i}", user_id: user.id).send("#{type}!".to_sym)
      end
    end

    context "get current profile" do

      it 'should return firts user\'s profile when no one profile marked as selected' do
        user.reload
        expect(user.current_profile.id).to eq(user.profiles.first.id)
      end

      it 'should return last selected profile when no one profile is selected' do
        user.profiles.each_with_index do | profile, i |
          profile.update_column(:become_current_at, (Profile.count - i).days.ago)
        end
        expect(user.current_profile.id).to eq(user.profiles.last.id)
      end

      it 'should return last selected profile when no one profile is selected' do
        user.profiles.each_with_index do | profile, i |
          profile.update_column(:become_current_at, (Profile.count - i).days.ago)
        end
        expect(user.current_profile.id).to eq(user.profiles.last.id)
      end

      it 'should return selected profile' do
        selected_profile = user.profiles.first(rand(1..3)).last
        selected_profile.update_column(:current, true)
        expect(user.current_profile.id).to eq(selected_profile.id)
      end

    end

    context "set current profile" do

      it 'should return selected profile' do
        selected_profile = user.profiles.first(rand(1..3)).last
        user.set_current_profile(selected_profile.id)
        selected_profile.reload
        expect(selected_profile.current).to be(true)
        expect(selected_profile.become_current_at.nil?).to be(false)
      end

    end

  end

end
