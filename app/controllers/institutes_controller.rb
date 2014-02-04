class InstitutesController < ApplicationController
  def index
    @institutes = Institute.all
  end

  def new
    @institute = Institute.new
    set_states
    @cities = @states.first.cities.order_name
  end

  def create
    @institute = Institute.new(institute_params)
    respond_to do |format|
      if @institute.save
        format.html {redirect_to institutes_path, notice:  "Instituto #{@institute.name} creado."}
      else
        set_states
        @cities = State.find(params[:institute_state]).cities.order_name
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @institute = Institute.find(params[:id])
    respond_to do |format|
      if @institute.update(institute_params)
        format.html {redirect_to institutes_path, :notice => "Instituto #{@institute.name} actualizado."}
      else
        set_states
        @cities = State.find(params[:institute_state]).cities.order_name
        format.html { render action: 'edit' }
      end
    end
  end

  def edit
    @institute = Institute.find(params[:id])
    set_states
    @cities = @institute.state.cities.order_name
  end

  def update_city
    @cities = State.find(params[:state_id]).cities.order_name
    render :json => { :cities => @cities}
  end

  private

  def set_states
    @states = State.all
  end

  def institute_params
    params.require(:institute).permit(:name, :contact, :phone, :email, :city_id )
  end
end
