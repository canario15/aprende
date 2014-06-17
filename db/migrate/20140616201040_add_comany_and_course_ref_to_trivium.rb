class AddComanyAndCourseRefToTrivium < ActiveRecord::Migration
  def change
    add_reference :trivium, :company, index: true
  end
end
