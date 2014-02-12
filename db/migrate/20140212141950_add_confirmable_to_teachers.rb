class AddConfirmableToTeachers < ActiveRecord::Migration
  def self.up
    add_column :teachers, :confirmation_token, :string
    add_column :teachers, :confirmed_at, :datetime
    add_column :teachers, :confirmation_sent_at, :datetime
    add_index :teachers, :confirmation_token, :unique => true

    Teacher.update_all(:confirmed_at => Time.now)
 end

  def self.down
    remove_columns :teachers, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
