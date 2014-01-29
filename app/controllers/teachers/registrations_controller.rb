class Teachers::RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params.require(:teacher).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :description)
  end
  private :sign_up_params
end

