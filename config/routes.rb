Homework::Application.routes.draw do
  resources :refreshes

  resources :exercises

  resources :repos

  resources :users

  root 'main#root'
  get '/auth/github/callback' => 'main#login_from_github'
end
