class Institute < ActiveRecord::Base
  belongs_to :city
  has_one :state,  :through => :city
  has_and_belongs_to_many :teachers,
      class_name: "Teacher",
      foreign_key: "institute_id",
      association_foreign_key: "teacher_id",
      join_table: "institutes_teachers"

  validates :name, :presence => true

  def to_s
    self.name
  end

end
