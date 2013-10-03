json.array!(@refreshes) do |refresh|
  json.extract! refresh, :user_id, :repo_id, :exercise_id, :logged_at
  json.url refresh_url(refresh, format: :json)
end
