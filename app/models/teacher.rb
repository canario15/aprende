class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :trivium
  has_many :games, through: :trivium
  belongs_to :city
  validates :first_name,:last_name, presence: true


  has_attached_file :avatar, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50" }, :default_url => "/assets/:style/missing.jpg"

  has_and_belongs_to_many :institutes,
      class_name: "Institute",
      foreign_key: "teacher_id",
      association_foreign_key: "institute_id",
      join_table: "institutes_teachers"

  before_save :capitalize_first_name

  scope :system_teachers, -> { order(first_name: :asc) }
  scope :with_games_week_ago, -> { includes(:games).where("games.updated_at >= ?",1.week.ago).references(:games) }

  def name
    (first_name.nil? ? "" : first_name) + " " + (last_name.nil? ? "" : last_name)
  end

  def to_s
    self.name
  end

  def games_finished
    self.games.finished
  end

  def password_required?
    !(persisted? and @attributes_cache.include? "id" and !@attributes_cache.include? "encrypted_password" )
  end

  def first_sign_in?
    self.sign_in_count == 1
  end

  def self.send_email
    teachers = Teacher.with_games_week_ago
    teachers.each do |teacher|
      TeacherMailer.trivia_statistics(teacher).deliver
    end
  end

  private

  def capitalize_first_name
    self.first_name = self.first_name.try(&:humanize).try(&:titleize)
  end

end
