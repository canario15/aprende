module UsersHelper

  def all_institutes
    Institute.system_institutes(current_company)
  end

end
