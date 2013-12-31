class CoursesController < ApplicationController
  layout 'landing_page'

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
    @levels = Level.all
  end

  def create
    Course.create(course_params)
    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end

  def edit
    @course = Course.find(params[:id])
    @levels = Level.all
  end

  def update
    @course = Course.find(params[:id])
    @course.update_attributes(course_params)
    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :level_id)
  end
end
