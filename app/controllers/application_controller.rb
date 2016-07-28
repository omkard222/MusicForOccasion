# default rails application controller
class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper_method :forced_sign_out
  layout :layout_by_resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_booker_profile

  before_filter :authenticate if ENV['STAGING_PASSWORD'] && ENV['STAGING_PASSWORD'].size > 0
  include ApplicationHelper

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == ENV['STAGING_PASSWORD']
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if session[:is_musician] && !Profile.where(user_id: resource.id).exists?
        new_profile_path(type: :musician)
      else
        super
      end
  end

  def set_booker_profile
    if current_user && current_user.current_profile && current_user.current_profile.profile_type == "registered_user"
      redirect_to profile_type_profiles_path(edit: true) unless current_user.current_profile.sub_type
    end
  end

  private

  def translate(dot_key)
    _controller_name = self.class.to_s.sub('Controller', '').underscore
    _action_name = caller_locations(1,1)[0].label.split.last
    I18n.t("controllers.#{_controller_name}.#{_action_name}#{dot_key}")
  end

  protected

  def layout_by_resource
    if controller_name == "registrations"  && action_name == "new"
      "login"
    elsif controller_name == "profiles"  && action_name == "new"
      "login"
    elsif controller_name == "sessions"  && action_name == "new"
      "login"
    else
      "application"
    end
  end
end
