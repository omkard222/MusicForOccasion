# Dashboard for managing informations
class DashboardsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  def summary
    if current_user.current_profile
      @profile = current_user.current_profile
      @receipt = current_user.mailbox.receipts.where.not(
        mailbox_type: nil).last
    else
      redirect_to new_profile_path
    end
  end
end
