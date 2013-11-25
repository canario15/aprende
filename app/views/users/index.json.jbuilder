json.array!(@users) do |user|
  json.extract! user, :name, :email, :group, :school
  json.url user_url(user, format: :json)
end
