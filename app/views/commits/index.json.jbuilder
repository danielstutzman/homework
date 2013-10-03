json.array!(@commits) do |commit|
  json.extract! commit, :user_id, :repo_id, :sha, :message, :exercise_dirs_csv, :committed_at
  json.url commit_url(commit, format: :json)
end
