class RemoveImageAndAddImagePaperclipToQuestion < ActiveRecord::Migration
   def self.up
   	remove_column :questions, :image
    add_attachment :questions, :image
  end

  def self.down
    remove_column :questions, :image
    add_column :questions, :image, :binary
  end
end
