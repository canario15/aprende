class Content < ActiveRecord::Base
  belongs_to :containable, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :containable
  validates :containable, presence: true

  TYPE =["Pdf",  "Written"]

  def containable_attributes=(attributes)
    if attributes[:id].blank?
      self.containable = eval(self.containable_type).new(attributes)
    else
      if self.containable.present?
        self.containable.update(attributes)
        super
      else
        self.containable = eval(self.containable_type).new(attributes.reject!{|key,val| key == :id})
      end
    end
  end
end