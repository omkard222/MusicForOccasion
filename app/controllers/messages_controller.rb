# Controller for managing messaging
class MessagesController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_any!
  def create
    recipient = Profile.find(params[:id])
    current_admin_or_profile.send_message(
      recipient,
      params[:msg_body],
      "Message from #{ username }")
    redirect_to conversation_path(recipient)
  end

  def message_for_admin
    recipient = Admin.find(params[:id])
    current_admin_or_profile.send_message(
      recipient,
      params[:msg_body],
      "Message from #{ username }")
    flash[:success] = 'Message delivered.'
    redirect_to admin_conversation_path(recipient)
  end
end
