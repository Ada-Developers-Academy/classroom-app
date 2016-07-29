Rails.application.routes.draw do
  root 'pull_requests#index'

  resources :repos
  resources :students
  get "/.well-known/acme-challenge/#{ENV['LE_AUTH_REQUEST']}", to: 'pull_requests#letsencrypt'

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
