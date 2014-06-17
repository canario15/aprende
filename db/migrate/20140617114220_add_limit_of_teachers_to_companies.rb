class AddLimitOfTeachersToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :limit_of_teachers, :integer
  end
end
