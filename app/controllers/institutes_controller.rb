class InstitutesController < ApplicationController
  def index
    @institutes = Institute.system_institutes(current_company)
  end

  def new
    @institute = Institute.new
  end

  def create
    institute_params_aux = institute_params.merge(company: current_company)
    @institute = Institute.new(institute_params_aux)
    respond_to do |format|
      if @institute.save
        format.html { redirect_to institutes_path, notice:  "Área #{@institute.name} creada." }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @institute = Institute.system_institutes(current_company).find(params[:id])
    respond_to do |format|
      if @institute.update(institute_params)
        format.html { redirect_to institutes_path, :notice => "Área #{@institute.name} actualizada." }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def edit
    @institute = Institute.system_institutes(current_company).find(params[:id])
  end

  def update_city
    @cities = State.find(params[:state_id]).cities.order_name
    render :json => { :cities => @cities}
  end

  private

  def institute_params
    params.require(:institute).permit(:name, :contact, :phone, :email, :company_id, :city_id )
  end
end
