User.transaction do

  daniel = User.create! github_username: 'danielstutzman'

  homework_repo = Repo.create! \
    user:      daniel,
    name:      'homework',
    https_url: 'https://github.com/danielstutzman/homework',
    has_exercise_dirs: false,
    is_not_found: false # will be set to true upon login

  lesson1 = LessonPlan.create! \
    date: Date.new(2013, 10, 7),
    topic: 'First Day',
    content: "This is a test"

  one_hundred = Exercise.create! \
    id: 100,
    lesson_plan: lesson1,
    first_line: 'test'

  Refresh.create! \
    user: daniel,
    repo: homework_repo,
    exercise_dir: '100',
    exercise: one_hundred,
    logged_at: DateTime.now

  SidebarLink.create! \
    name: 'Gallery',
    url: 'http://dvc-projects.tumblr.com'
  SidebarLink.create! \
    name: 'HipChat',
    url: 'https://davincicoders.hipchat.com/home'

end # end transaction
