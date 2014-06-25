class CompaniesController < ApplicationController


  def edit
    begin
      @company = current_admin.company
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to edit_compnay_path, :alert => "Acceso denegado" }
      end
    end
  end

  def update
    @company = current_admin.company
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to courses_path, :notice => "Empresa #{@company.name} actualizada." }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :contact_name, :phone, :address)
  end

end
