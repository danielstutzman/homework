User.transaction do

  daniel = User.create! github_username: 'danielstutzman', is_admin: true

  homework_repo = Repo.create! \
    user:      daniel,
    name:      'homework',
    https_url: 'https://github.com/danielstutzman/homework',
    has_exercise_dirs: false,
    is_not_found: false
  my_repo = Repo.create! \
    user:      daniel,
    name:      '2013-q4-ruby',
    https_url: 'https://github.com/davincicoders/2013-q4-ruby',
    has_exercise_dirs: true,
    is_not_found: false

  lesson1 = LessonPlan.create! \
    date: Date.new(2013, 10, 7),
    topic: 'First Day',
    content: "This is a test"

  one_hundred = Exercise.create! \
    lesson_plan: lesson1,
    first_line: 'test',
    content: 'test',
    order_in_lesson: 1

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

  Commit.create! \
    user: daniel,
    repo: my_repo,
    sha: '154ca500a13d31fd4d3c578621dea0a388dc62bc',
    message: 'Added cd, edit, and ls pages to 101.',
    exercise_dir: '100',
    exercise: one_hundred,
    committed_at: '2013-10-04 23:12:08'

end # end transaction
