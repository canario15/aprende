class TeachersController < ApplicationController

  def index
  	@teachers= Teacher.system_teachers
  end

end
