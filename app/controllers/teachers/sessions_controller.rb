class Teachers::SessionsController < Devise::SessionsController

  def create
    teacher = Teacher.find_by(email: params[:teacher][:email])
    if teacher.try(:inactive)
      flash.now[:alert] = t 'devise.failure.inactive_by_admin'
      redirect_to new_teacher_session_path
    else
      super
    end
  end
end

