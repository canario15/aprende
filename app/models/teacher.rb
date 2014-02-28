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
  scope :games_played, -> {includes(:games).where("created_at >= ?",1.week.ago ).distinct}

  def name
    (first_name.nil? ? "" : first_name) + " " + (last_name.nil? ? "" : last_name)
  end

  def to_s
    self.name
  end

  def games_finished
    self.games.finished
  end

  def games_week_ago
    self.games.week_ago
  end

  def update_without_password?
    update_without_password
  end

  def first_sign_in?
    self.sign_in_count == 1
  end

  def games_average_score
    self.games.select("count(*) as count, trivium.id as trivia_id, trivium.title as trivium_title, avg(games.score) as avg_score, games.id as game_id").week_ago.finished.group("trivia_id")
  end

  def send_email
    @teachers_with_games = Teacher.games_played
    @teachers_with_games.each do |t|
      @teacher = t
      TeacherMailer.trivia_statistics(@teacher).deliver
    end
  end

end
