class Users::RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :level_id, :institute_id, :city_id, :avatar)
  end
  private :sign_up_params
end

