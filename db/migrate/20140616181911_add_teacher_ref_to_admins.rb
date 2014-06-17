class AddTeacherRefToAdmins < ActiveRecord::Migration
  def change
    add_reference :admins, :teacher, index: true
  end
end
