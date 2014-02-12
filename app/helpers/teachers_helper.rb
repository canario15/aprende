module TeachersHelper

  def teacher_name_inactive(teacher)
    teacher.inactive ? "Activar" : "Inactivar"
  end

end
