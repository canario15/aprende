class ApplicationController < ActionController::Base
  layout :layout_by_resource

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
