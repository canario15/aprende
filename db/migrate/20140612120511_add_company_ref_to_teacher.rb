class AddCompanyRefToTeacher < ActiveRecord::Migration
  def change
    add_reference :teachers, :company, index: true
  end
end
