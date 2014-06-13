class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index,:show,:new,:create,:destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.system_users(current_company)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
      if current_user == @user
        @user = User.find(params[:id])
        format.html { render action: 'edit' }
      else
        format.html {redirect_to home_path, :alert => "Acceso restringido."}
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    password = Devise.friendly_token.first(8)
    user_params_pass = user_params.merge(:password => password, :password_confirmation => password, company: current_company)
    @user = User.new(user_params_pass)
    @user.skip_confirmation!
    respond_to do |format|
      if @user.save
        @user.send_reset_password_instructions
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json

  def update
    respond_to do |format|
      if current_user == @user
        if @user.update(user_params)
          format.html {redirect_to home_path, :notice => "Datos de #{@user.name} actualizados."}
        else
          format.html { render action: 'edit' }
        end
      else
        format.html {redirect_to home_path, :alert => "Acceso restringido."}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :institute_id, :city_id, :avatar)
    end
end
