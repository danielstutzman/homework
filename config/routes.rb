Homework::Application.routes.draw do
  root 'main#root'
  get '/auth/github/callback' => 'main#login_from_github'
end
