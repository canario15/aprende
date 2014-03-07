class CreatePdfs < ActiveRecord::Migration
  def change
    create_table :pdfs do |t|
      t.has_attached_file :document
      t.timestamps
    end
  end
end