Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :repos
  resources :students
  resources :pull_requests

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
