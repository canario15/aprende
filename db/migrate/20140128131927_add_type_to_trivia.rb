class AddTypeToTrivia < ActiveRecord::Migration
  def change
    add_column :trivium, :type, :integer
  end
end
