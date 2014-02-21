class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :trivium
  has_many :games, through: :trivium
  belongs_to :city

  attr_accessor :update_without_password

  validates :password, :presence => true, :unless => :update_without_password?

  has_attached_file :avatar, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50" }, :default_url => "/assets/:style/missing.jpg"

  has_and_belongs_to_many :institutes,
      class_name: "Institute",
      foreign_key: "teacher_id",
      association_foreign_key: "institute_id",
      join_table: "institutes_teachers"

  scope :system_teachers, -> { order(first_name: :asc)}

  def name
    (first_name.nil? ? "" : first_name) + " " + (last_name.nil? ? "" : last_name)
  end

  def to_s
    self.name
  end

  def games_finished
    self.games.finished
  end

  def update_without_password?
    update_without_password
  end
end
