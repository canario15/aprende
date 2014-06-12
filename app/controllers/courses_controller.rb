class CoursesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    Course.create(course_params)
    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end

  def edit
    @course = Course.find(params[:id])
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
    params.require(:course).permit(:title, :image)
  end
end
