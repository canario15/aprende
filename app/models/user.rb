class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable

  belongs_to :institute
  belongs_to :company
  has_many :games
  belongs_to :city
  validates :institute, :company, :first_name,:last_name, presence: true

  scope :system_users, ->{order(first_name: :asc)}
  has_attached_file :avatar, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50" }, :default_url => "/assets/:style/missing.jpg"

  before_save :capitalize_first_name

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.confirm!
    end
  end

  def name
    (first_name.nil? ? "" : first_name) + " " + (last_name.nil? ? "" : last_name)
  end

  def to_s
    self.name
  end

  def games_finished
    self.games.finished
  end

  def first_sign_in?
    self.sign_in_count == 1
  end

  def password_required?
    !(persisted? and @attributes_cache.include? "id" and !@attributes_cache.include? "encrypted_password" )
  end

  private

  def capitalize_first_name
    self.first_name = self.first_name.try(&:humanize).try(&:titleize)
  end
end
