class ApplicationController < ActionController::Base
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    if resource.class.to_s == Constants::RESOURCE_TYPE[:teacher]
      games_path
    elsif resource.class.to_s == Constants::RESOURCE_TYPE[:user]
      home_path
    elsif resource.class.to_s == Constants::RESOURCE_TYPE[:admin]
      courses_path
    else
      home_path
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      "landing_page"
    else
      "application"
    end
  end

  def resource
    @user
  end
  helper_method :resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

end
