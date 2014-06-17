class CoursesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = Course.system_courses(current_company)
  end

  def new
    @course = Course.new
  end

  def create
    course_params_aux = course_params.merge(company: current_company)
    @course = Course.create(course_params_aux)
    respond_to do |format|
      if @course.save
        format.html { redirect_to courses_url, notice:  "Curso creado." }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def edit
    @course = Course.system_courses(current_company).find(params[:id])
  end

  def update
    @course = Course.system_courses(current_company).find(params[:id])
    @course.update_attributes(course_params)
    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :image, :company_id)
  end
end
