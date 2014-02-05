class AddAdminUser < ActiveRecord::Migration
  def change
    Admin.create!(email: "admin@vairix.com", password: "123456789")
  end
end
