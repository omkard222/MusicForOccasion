require 'rails_helper'

describe BookingStatusMailer, type: :mailer do
  let(:booking) { create :booking_request }
  let(:footer_image_url) { ActionController::Base.helpers.asset_url('mailer/footer.png') }
  let(:header_image_url) { ActionController::Base.helpers.asset_url('mailer/header.png') }
  subject(:mail_body) { mail.body.encoded }
  let(:recieved_mail_body) { ActionMailer::Base.deliveries.last.body.encoded }

  shared_examples 'a booking email' do
    it { expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it { expect(mail_body).to match("Hello #{profile.display_name}") }
    it { expect(mail_body).to match(notifications_url) }
    it 'contains footer image' do
      mail.deliver_now
      expect(recieved_mail_body).to match(footer_image_url)
    end
    it 'contains header image' do
      mail.deliver_now
      expect(recieved_mail_body).to match(header_image_url)
    end
    it { expect(mail_body).to match(privacy_policy_url) }
  end

  describe '.service_creation_notification' do
    let(:profile) { create :profile }

    it_behaves_like 'a booking email' do
      let(:mail) { BookingStatusMailer.service_creation_notification(profile) }
    end
  end

  describe '.new_booking_request_service_owner_notification' do
    let(:profile) { booking.service_proposer }
    let(:mail) { BookingStatusMailer.new_booking_request_service_owner_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.profile)) }
  end

  describe '.accept_booking_request_requestor_notification' do
    let(:profile) { booking.profile }
    let(:mail) { BookingStatusMailer.accept_booking_request_requestor_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service.profile)) }
  end


  describe '.cancel_booking_request_service_owner_notification' do
    let(:profile) { booking.service_proposer }
    let(:mail) { BookingStatusMailer.cancel_booking_request_service_owner_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.profile)) }
  end

  describe '.reject_booking_request_requestor_notification' do
    let(:profile) { booking.profile }
    let(:mail) { BookingStatusMailer.reject_booking_request_requestor_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service.profile)) }
  end

  describe '.special_offer_booking_request_requestor_notification' do
    let(:profile) { booking.profile }
    let(:mail) { BookingStatusMailer.special_offer_booking_request_requestor_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service.profile)) }
  end


  describe '.accept_special_offer_booking_request_service_owner_notification' do
    let(:profile) { booking.service_proposer }
    let(:mail) { BookingStatusMailer.accept_special_offer_booking_request_service_owner_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service.profile)) }
  end

  describe '.reject_special_offer_booking_request_service_owner_notification' do
    let(:profile) { booking.service_proposer }
    let(:mail) { BookingStatusMailer.reject_special_offer_booking_request_service_owner_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service.profile)) }
  end


  describe '.cancel_special_offer_booking_request_service_owner_notification' do
    let(:profile) { booking.profile }
    let(:mail) { BookingStatusMailer.cancel_special_offer_booking_request_service_owner_notification(booking) }

    it_behaves_like 'a booking email'
    it { expect(mail_body).to match(conversation_url(booking.service_proposer)) }
  end


  describe '.cancel_confirmed_booking_request_requestor_notification' do
    context 'updated by requestor' do
      let(:profile) { booking.service_proposer }
      before { booking.update(updated_by_id: booking.profile.user_id) }
      let(:mail) { BookingStatusMailer.cancel_confirmed_booking_request_requestor_notification(booking) }
      
      it_behaves_like 'a booking email'
      it { expect(mail_body).to match(conversation_url(booking.profile)) }
    end

    context 'updated by service owner' do
      let(:profile) { booking.profile }
      let(:mail) { BookingStatusMailer.cancel_confirmed_booking_request_requestor_notification(booking) }
            
      it_behaves_like 'a booking email'
      it { expect(mail_body).to match(conversation_url(booking.service_proposer)) }
    end
  end
end
