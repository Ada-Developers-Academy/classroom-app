Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :assignments do
    resources :classroom, only: [:show], controller: 'assignments'

    resources :students, only: [] do
      resources :feedback, only: [:new, :create]
    end
  end

  resources :cohorts
  resources :classrooms
  resources :submissions
  resources :students
  resources :pull_requests
  resources :user_invites, only: [:index, :create], path: 'invites' do
    collection do
      %w(student instructor).each do |role|
        get "/new/#{role}", action: "new_#{role}", as: "new_#{role}"
      end
    end
  end

  resources :instructors#, only: [:index, :create, :show]
  # Api calls:
  # get "/assignmentsapi", to: "assignments#index"
  # get "/studentsapi", to: "students#index"
  # get "/classroomsapi", to: "classrooms#index"
  # get "/cohortsapi", to: "cohorts#index"

  get "/auth/:provider/callback", to: "sessions#create" # , format: false # QUESTION: need the format thing?

  delete "/logout", to: "sessions#destroy"

end
