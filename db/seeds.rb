daniel = User.create! github_username: 'danielstutzman'

homework_repo = Repo.create! \
  user: daniel,
  url: 'https://github.com/danielstutzman/homework'

_100_dir = Exercise.create! dir_name: '100'

Refresh.create! \
  user: daniel,
  repo: homework_repo,
  exercise: _100_dir,
  logged_at: DateTime.now
