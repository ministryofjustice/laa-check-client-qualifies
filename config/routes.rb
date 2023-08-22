Rails.application.routes.draw do
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show create]
  resource :referrals, only: [:show]

  resources :estimates, only: %i[new create show] do
    resources :build_estimates, only: %i[show update]
    resources :check_answers, only: %i[show update]

    member { get :print, :check_answers, :download }

    resources :controlled_work_document_selections, only: %i[new create]
  end

  resource :cookies, only: %i[show update]
  resource :privacy, as: :privacy, only: :show
  resource :accessibility, only: :show
  resource :help, only: :show
  resources :feature_flags, only: %i[index edit update], path: "feature-flags"
  resources :updates, only: :index
  resources :basic_authentication_sessions, only: %i[new create]
  resources :documents, only: :show do
    collection do
      get :pdf_worker
    end
    member do
      get :download
    end
  end
  get "/no-analytics", to: "cookies#no_analytics_mode"
  get "instant-:session_type", to: "instant_sessions#create", as: :instant_session
  get "robots.txt", to: "robots#index"

  mount Blazer::Engine, at: "data"
end
