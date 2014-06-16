class Institute < ActiveRecord::Base
  belongs_to :city
  belongs_to :company
  has_one :state,  :through => :city
  has_and_belongs_to_many :teachers,
      class_name: "Teacher",
      foreign_key: "institute_id",
      association_foreign_key: "teacher_id",
      join_table: "institutes_teachers"

  scope :system_institutes, ->(company) { where(:company_id => company.id).order(name: :asc) }

  validates :name, :presence => true
  validates :company, :presence => true

  def to_s
    self.name
  end

end