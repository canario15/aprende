module UsersHelper

  def all_institutes
    Institute.company_institutes(current_user)
  end

end
