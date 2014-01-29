class AddAttributesToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :first_name, :string
    add_column :teachers, :last_name, :string
    add_column :teachers, :phone, :string
    add_column :teachers, :description, :text
  end
end
