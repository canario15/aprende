class Admins::SessionsController < Devise::SessionsController
  def new
    if member_signed_in?
      redirect_to welcome_index_path
    else
      super
    end
  end

  def switch
    sign_in (current_admin.teacher)
    sign_out(current_admin)
    redirect_to games_teacher_path
  end
end

