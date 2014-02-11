class TeachersController < ApplicationController

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
        format.html {redirect_to teachers_path, :notice => "Datos de #{@teacher.name} actualizados."}
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :phone, :description)
  end

end
