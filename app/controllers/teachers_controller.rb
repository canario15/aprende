class TeachersController < ApplicationController
  before_filter :authenticate_admin!, :only => [:index]

  def index
    @teachers= Teacher.system_teachers
  end

  def edit
    @teacher = Teacher.find(params[:id])
    @institutes = Institute.all
  end

  def update
    @teacher = Teacher.find_by(id: params[:id])
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html {redirect_to games_teacher_path(@teacher), :notice => "Datos de #{@teacher.name} actualizados."}
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def inactivate_or_activate
    teacher = Teacher.find(params[:teacher_id])
    inactive = nil
    if teacher.inactive
      inactive = false
    else
      inactive = true
    end
    params.merge!({teacher: {inactive: inactive}})
    respond_to do |format|
      if teacher.update(teacher_params)
        format.json { render json: { result: true, inactive: teacher.inactive } }
      else
        format.json { render json: { result: false, inactive: teacher.inactive } }
      end
    end
  end

  private

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :phone, :description, :city_id, {institute_ids: []}, :inactive)
  end

end
