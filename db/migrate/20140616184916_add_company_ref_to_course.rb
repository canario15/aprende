class AddCompanyRefToCourse < ActiveRecord::Migration
  def change
    add_reference :courses, :company, index: true
  end
end
