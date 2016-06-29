module Users
  class PasswordsController < Devise::PasswordsController
    layout 'login'
    include ApplicationHelper

    # GET /user/password/new
    def new
      self.resource = resource_class.new
    end
  end
end
