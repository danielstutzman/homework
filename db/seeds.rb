daniel = User.create! github_username: 'danielstutzman'

homework_repo = Repo.create! \
  user:      daniel,
  name:      'homework',
  https_url: 'https://github.com/danielstutzman/homework',
  has_exercise_dirs: false

_100_dir = Exercise.create! dir_name: '100'

Refresh.create! \
  user: daniel,
  repo: homework_repo,
  exercise: _100_dir,
  logged_at: DateTime.now

LessonPlan.create! \
  date: Date.new(2013, 10, 5),
  topic: 'Install Fest',
  content: "This is a test"
