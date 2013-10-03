Homework::Application.routes.draw do
  resources :lesson_plans

  resources :commits

  root 'main#root'

  get '/auth/github/callback' => 'main#login_from_github'

  resources :users
  resources :repos
  resources :exercises
  resources :refreshes

  post '/github_webhook' => 'main#github_webhook'
end
