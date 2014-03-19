class Teachers::SessionsController < Devise::SessionsController
  def new
    if member_signed_in?
      redirect_to welcome_index_path
    else
      super
    end
  end

  def create
    teacher = Teacher.find_by(email: params[:teacher][:email])
    if teacher.try(:inactive)
      flash[:alert] = t 'devise.failure.inactive_by_admin'
      redirect_to new_teacher_session_path
    else
      super
    end
  end
end

