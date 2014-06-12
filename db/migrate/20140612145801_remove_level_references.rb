class RemoveLevelReferences < ActiveRecord::Migration
  def change
    remove_column :courses, :level_id
    remove_column :users, :level_id
  end
end
