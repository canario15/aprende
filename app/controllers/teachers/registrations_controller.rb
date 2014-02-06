class Teachers::RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:teacher).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :description, :city_id, :avatar)
  end

  private :sign_up_params
end

