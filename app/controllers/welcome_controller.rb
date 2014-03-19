class WelcomeController < ApplicationController
  layout 'landing_page'

  def index
    if current_user
      redirect_to home_path
    elsif current_teacher
      redirect_to games_teacher_path
    elsif current_admin
      redirect_to courses_path
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
