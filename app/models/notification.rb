class Notification < ActiveRecord::Base
  scope :active_all, -> {where(active:true)}

  def inactivate
    self.active = false
  end
end
