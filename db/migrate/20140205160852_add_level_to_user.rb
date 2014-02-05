class AddLevelToUser < ActiveRecord::Migration
  def change
    add_reference :users, :level, index: true
  end
end
