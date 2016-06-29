module Admins
  # rails_admin base controller
  class BaseController < ApplicationController
    def send_reset_password_instruction
      user = User.find(params[:id])
      user.send_reset_password_instructions
      redirect_to rails_admin.edit_path(model_name: 'admin~user',
                                        id: user.id)
    end
  end
end
