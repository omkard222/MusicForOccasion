require 'rails_helper'

describe Profile do
  before do
    @profile = FactoryGirl.create(:profile)
  end

  subject { @profile }

  it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
  it { should have_many :additional_pictures }
  it { should belong_to :user }
  it { should validate_uniqueness_of(:stage_name).ignoring_case_sensitivity }
  it { should have_many :musician_genres }
  it { should have_many(:genres).through(:musician_genres) }
  it { should have_many(:services).dependent(:destroy) }
  it { should have_many(:booking_requests).dependent(:destroy) }

  it 'should vaildate presence of username or stage_name' do
    expect(build(:profile, stage_name: nil, username: nil)).not_to be_valid
    expect(build(:profile, stage_name: 'Some name', username: nil)).to be_valid
    expect(build(:profile, stage_name: nil, username: 'Some name')).to be_valid
  end

  describe 'collect_reviews' do

    let(:reviewer) { create(:profile) }

    before :each do
      FactoryGirl.create(:review, profile: @profile, reviewer_id: reviewer.id)
      FactoryGirl.create(:review, profile: @profile, reviewer_id: nil)
      FactoryGirl.create(:review, profile: @profile, reviewer_id: 123)
    end

    it 'does not return reviews without reviewer' do
      expect(@profile.collect_reviews.count).to eq(1)
    end

  end

  describe 'soundcloud data' do

    let(:user) { create(:valid_user) }
    let(:profile) { create(:profile, user: user) }

    let(:code) { '703e4b925e2f7468078b072af4a5442a' }

    describe 'soundcloud data creation' do

      before :each do
        stub_request(:post, 'https://api.soundcloud.com/oauth2/token').
          to_return(status: 200, body: { access_token: '1-182423-209423212-e14862fbff696',
                                         expires_in: 21599,
                                         scope: '*',
                                         refresh_token: 'fea68e89b99e3e148c6367dc2acbc00c' }.to_json,
                    headers: { 'Content-Type' => 'application/json; charset=utf-8' })
        stub_request(:get, 'https://api.soundcloud.com/me?format=json&oauth_token=1-182423-209423212-e14862fbff696').
          to_return(status: 200, body: { id: '209423212' }.to_json,
                    headers: { 'Content-Type' => 'application/json; charset=utf-8' })
        end

        it 'creates new soundcloud datum and put new dalayed job in queue' do
          jobs_count = Delayed::Job.count
          expect { profile.process_soundcloud_authorization_response(code) }.to change(SoundcloudDatum, :count).from(0).to(1)
          expect(Delayed::Job.count).to eq(jobs_count + 1)
        end

    end

    describe 'get number of tracks plays' do

      let(:soundcloud_datum) { create(:soundcloud_datum, profile: profile) }

      context 'stubbed to return 600 tracks' do
        before :each do
          stub_request(:get, "https://api.soundcloud.com/users/123456789/tracks?format=json&oauth_token=#{soundcloud_datum.access_token}").
            to_return(status: 200, body: [{ playback_count: 100 },
                                          { playback_count: 500 }].to_json,
                      headers: { 'Content-Type' => 'application/json; charset=utf-8' })
        end

        it 'checks the getting of plays count from sountcloud' do
          expect(profile.get_tracks_plays).to eq(600)
        end

        it 'does not delete soundcloud data' do
          expect { profile.get_tracks_plays }.not_to change(SoundcloudDatum, :count)
        end
      end

      context 'unauthorized' do
        before :each do
          stub_request(:get, "https://api.soundcloud.com/users/123456789/tracks?format=json&oauth_token=#{soundcloud_datum.access_token}").
            to_return status: 401
        end

        it 'delete soundcloud data if profile does not authorized' do
          expect { profile.get_tracks_plays }.to change(SoundcloudDatum, :count).by(-1)
        end
      end
    end

    describe 'get_soundcloud_user_info' do
      let(:soundcloud_datum) { create(:soundcloud_datum, profile: profile) }

      before :each do
        stub_request(:get, "https://api.soundcloud.com/me?format=json&oauth_token=#{soundcloud_datum.access_token}").
          to_return(status: 200, body: { followers_count: 200, permalink: 'test' }.to_json,
                    headers: { 'Content-Type' => 'application/json; charset=utf-8' })
      end

      it 'checks the getting of plays count from sountcloud' do
        expect(profile.get_soundcloud_user_info).to eq({ followers_count: 200, permalink: 'test' })
      end

    end

  end

end
