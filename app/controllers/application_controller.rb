class ApplicationController < ActionController::Base
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    if resource.class.to_s == Constants::RESOURCE_TYPE[:teacher]
      resource.first_sign_in? ? edit_teacher_path(resource) : games_teacher_path
    elsif resource.class.to_s == Constants::RESOURCE_TYPE[:user]
      resource.first_sign_in? ? edit_user_path(resource) : home_path
    elsif resource.class.to_s == Constants::RESOURCE_TYPE[:admin]
      courses_path
    else
      home_path
    end
  end

  protected

  def member_signed_in?
    ([:admin,:teacher,:user].any?{ |member| eval("#{member}_signed_in?") unless resource_name == member })
  end

  def layout_by_resource
    if devise_controller? && !((is_a? Devise::RegistrationsController) && (["edit","update"].include? action_name))
      "landing_page_responsive"
    else
      "application_responsive"
    end
  end

  def resource
    @user
  end
  helper_method :resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_company
    current_user.try(:company) || current_admin.try(:company) || current_teacher.try(:company)
  end 

end
