Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :repos do
    get "/cohort/:cohort_id", to: "repos#show", as: :cohort

    resources :students, only: [] do
      resources :feedback, only: [:new, :create]
    end
  end
  resources :students
  resources :pull_requests
  resources :user_invites, only: [:index, :new, :create] do
    collection do
      %w(student instructor).each do |role|
        get "/new/#{role}", action: :new, as: "new_#{role}", role: role
      end
    end
  end

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
