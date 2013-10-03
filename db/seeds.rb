daniel = User.create! github_username: 'danielstutzman'

homework_repo = Repo.create! \
  user:      daniel,
  name:      'homework',
  https_url: 'https://github.com/danielstutzman/homework',
  has_exercise_dirs: false

lesson1 = LessonPlan.create! \
  date: Date.new(2013, 10, 7),
  topic: 'First Day',
  content: "This is a test"

one_hundred = Exercise.create! id: 100, lesson_plan: lesson1

Refresh.create! \
  user: daniel,
  repo: homework_repo,
  exercise_dir: '100',
  exercise: one_hundred,
  logged_at: DateTime.now
