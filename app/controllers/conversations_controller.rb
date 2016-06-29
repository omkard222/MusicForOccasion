# Controller for managing conversations between users
class ConversationsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_any!
  def index
    @user_receipts = {}
    @conversations = current_model_receipts.where.not(
      mailbox_type: nil).all
    @conversations.each do |conversation|
      user = conversation.conversation_partner(current_admin_or_profile)
      next if @user_receipts.key?(user) || user.blank?

      @user_receipts[user] = conversation
    end
  end

  def show
    @receipts_history = []
    @receipts = current_model_receipts
    @receipts.each do |receipt|
      user = receipt.conversation_partner(current_admin_or_profile)
      next unless message_related_to_conversation?(user, receipt)
      receipt.mark_as_read
      @receipts_history << receipt
    end
    @talk_with = Profile.find(params[:id])
  end

  def admin # show conversations with admin
    @receipts_history_with_admin = []
    @receipts = current_model_receipts
    @receipts.each do |receipt|
      admin = receipt.conversation_partner(current_admin_or_profile)
      next unless admin == Admin.find(params[:id])
      receipt.mark_as_read
      @receipts_history_with_admin << receipt
    end
  end

  private

  def message_related_to_conversation?(user, receipt)
    @user = user
    @conversation_partner = Profile.find(params[:id])
    @user == @conversation_partner || receipt.related_system_message?(
      @conversation_partner)
  end

  def current_model_receipts
    current_admin_or_profile.mailbox.receipts.order(created_at: :desc).all 
  end
end
