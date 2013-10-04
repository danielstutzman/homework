Homework::Application.routes.draw do
  root 'main#root'

  get '/lessons/:month_day' => 'main#single_lesson'

  get '/auth/github/callback' => 'main#login_from_github'

  # use scope instead of namespace so I don't have to rewrite all
  # the scaffolding path helper calls.
  scope '/admin' do
    resources :users,        controller: 'admin/users'
    resources :repos,        controller: 'admin/repos'
    resources :exercises,    controller: 'admin/exercises'
    resources :refreshes,    controller: 'admin/refreshes'
    resources :lesson_plans, controller: 'admin/lesson_plans'
    resources :commits,      controller: 'admin/commits'
  end

  post '/github_webhook' => 'main#github_webhook'
end
