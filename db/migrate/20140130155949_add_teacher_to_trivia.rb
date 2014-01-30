class AddTeacherToTrivia < ActiveRecord::Migration
  def change
    add_reference :trivium, :teacher, index: true
  end
end
