class AddInactiveBooleanToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :inactive, :boolean, :default => false
  end
end
