class AddContentRefToTrivium < ActiveRecord::Migration
  def change
    add_reference :trivium, :content, index: true
  end
end
