class TeachersController < ApplicationController
  before_filter :authenticate_admin!, :only => [:index]

  def index
    @teachers= Teacher.system_teachers
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find_by(id: params[:id])
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html {redirect_to teacher_path, :notice => "Datos de #{@teacher.name} actualizados."}
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
    if teacher.inactive
      teacher.inactive = false
    else
      teacher.inactive = true
    end

    respond_to do |format|
      if teacher.save
        format.json { render json: { result: true, inactive: teacher.inactive } }
      else
        format.json { render json: { result: false, inactive: teacher.inactive } }
      end
    end
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :phone, :description, :city_id, {institute_ids: []})
  end

end
