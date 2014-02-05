class AddInstituteToUser < ActiveRecord::Migration
  def change
    add_reference :users, :institute, index: true
  end
end
