Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :repos do
    get "/cohort/:cohort_id", to: "repos#show", as: :cohort
    get "/student/:student_id/feedback/new", to: "feedback#new", as: :new_feedback
    post "/student/:student_id/feedback/", to: "feedback#create", as: :feedback
    resources :students do
      resources :feedback
    end
  end
  resources :students
  resources :pull_requests


  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
