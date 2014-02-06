class AddCityIdToTeacher < ActiveRecord::Migration
  def change
    add_reference :teachers, :city, index: true
  end
end
