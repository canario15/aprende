class Trivia < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :course
  belongs_to :teacher
  belongs_to :course
  has_many   :questions
  has_many   :games
  belongs_to :content, dependent: :destroy
  accepts_nested_attributes_for :content

  validates :title,:course,:type,:teacher, presence: true

  scope :with_questions, -> { joins(:questions).order(updated_at: :desc).uniq }
  scope :with_questions_and_limit, -> { with_questions.limit(3) }
  scope :search_with_questions, -> (q){ search({teacher_city_name_or_teacher_first_name_or_teacher_last_name_or_title_or_tag_cont: q}).result(distinct: true).with_questions }

  TYPES = {1 => I18n.t('trivia.type.multiple_choice'), 2 => I18n.t('trivia.type.free')}

  TYPE_MULTIPLE_CHOICE = TYPES.keys.first

  def type_name
    TYPES[self.type]
  end

  def with_no_games?
    self.games.blank?
  end

  def clone_with_associations
    new_trivia = self.dup
    new_trivia.course = self.course
    new_trivia.questions << self.questions.map do |old_q|
     new_q = old_q.dup
     new_q.image = old_q.image
     new_q
    end

    if self.content.present?
      new_trivia.content = self.content.dup
      new_trivia.content.containable = self.content.containable.dup
      new_trivia.content.containable.document = self.content.containable.document
    end
    new_trivia.save!
    new_trivia
  end

  def content_attributes=(attributes)
    attributes = {} if attributes.all?{|key,value| value[:containable_type].blank?}
    old_attributes = attributes
    is_valid = true

    if attributes.present?
      attributes.each do |key,value|
        value.symbolize_keys
        if value[:containable_type].present?
          attributes = value
        end
      end
      is_valid = Content.new(attributes).valid?
    end

    if is_valid and self.valid?
      if old_attributes.empty? and self.content.present?
        self.content.destroy
      end
      if old_attributes.any?{|key,value| value[:containable_type].blank? and not value[:id].blank?} and self.content.present?
        self.content.destroy
      end
    end

    super unless old_attributes.empty?
  end

  def contents_init
    if ( self.content.present?  and  not ( self.content.containable.present? and self.content.containable.document.present?))
      if self.persisted?
        if self.content.persisted?
          self.content.reload
          self.reload
        else
          self.reload
        end
      else
        self.content = nil
      end
    end
    contents_edit = self.content.present? ? [self.content] : []
    Content::TYPE.each do |model|
      unless self.content.present? and self.content.containable_type == model
        contents_edit << Content.new(containable: eval(model).new)
      end
    end
    contents_edit
  end

  def game_started_by_user(user)
    games.where( user_id: user.id, status: Game::STATUS[:started] ).first
  end

end
