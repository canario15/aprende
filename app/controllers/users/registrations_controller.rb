class Users::RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params.require(:user).permit(:course, :first_name, :last_name, :email, :password, :password_confirmation)
  end
  private :sign_up_params
end

