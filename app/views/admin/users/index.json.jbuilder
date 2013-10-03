json.array!(@users) do |user|
  json.extract! user, :github_username
  json.url user_url(user, format: :json)
end
