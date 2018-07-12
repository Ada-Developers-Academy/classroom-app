Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :assignments do
    resources :cohort, only: [:show], controller: 'assignments'

    resources :students, only: [] do
      resources :feedback, only: [:new, :create]
    end
  end
  resources :students
  resources :pull_requests
  resources :user_invites, only: [:index, :create], path: 'invites' do
    collection do
      %w(student instructor).each do |role|
        get "/new/#{role}", action: "new_#{role}", as: "new_#{role}"
      end
    end
  end

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
