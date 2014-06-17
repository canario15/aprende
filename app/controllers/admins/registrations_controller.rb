class Admins::RegistrationsController < Devise::RegistrationsController
  def new
    @admin = Admin.new
    @admin.build_company
    super
  end

  def create
    @admin = Admin.new(sign_up_params)
    if(@admin.valid?)
      unless (Teacher.find_by(sign_up_params.slice(:email)))
        super
        teacher = Teacher.new(sign_up_params.slice!(:company_attributes).merge({admin: @admin, company: @admin.company})).save(validate: false)
      else
        flash[:alert] = "Ya existe un instructor con ese email."
        respond_to do |format|
          format.html { render action: 'new'}
          format.json { render json: @admin.save.errors, status: :unprocessable_entity }
        end
      end
    else
      super
    end
  end

  def sign_up_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation, company_attributes: [:id,:name])
  end

  private :sign_up_params
end

