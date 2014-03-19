class InstitutesController < ApplicationController
  def index
    @institutes = Institute.all
  end

  def new
    @institute = Institute.new
  end

  def create
    @institute = Institute.new(institute_params)
    respond_to do |format|
      if @institute.save
        format.html { redirect_to institutes_path, notice:  "Instituto #{@institute.name} creado." }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @institute = Institute.find(params[:id])
    respond_to do |format|
      if @institute.update(institute_params)
        format.html { redirect_to institutes_path, :notice => "Instituto #{@institute.name} actualizado." }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def edit
    @institute = Institute.find(params[:id])
  end

  def update_city
    @cities = State.find(params[:state_id]).cities.order_name
    render :json => { :cities => @cities}
  end

  private

  def institute_params
    params.require(:institute).permit(:name, :contact, :phone, :email, :city_id )
  end
end
