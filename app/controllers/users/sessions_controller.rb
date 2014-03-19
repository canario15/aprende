class Users::SessionsController < Devise::SessionsController
  def new
    if member_signed_in?
      redirect_to welcome_index_path
    else
      super
    end
  end
end

