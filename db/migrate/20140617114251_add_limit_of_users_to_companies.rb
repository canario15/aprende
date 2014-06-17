class AddLimitOfUsersToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :limit_of_users, :integer
  end
end
