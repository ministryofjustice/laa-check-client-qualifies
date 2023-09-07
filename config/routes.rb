Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  devise_for :admins, controllers: { omniauth_callbacks: "admins/omniauth_callbacks" }
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show create]
  resource :referrals, only: [:show]

  resources :estimates, only: %i[new create show] do
    member { get :print, :check_answers, :download }

    resources :controlled_work_document_selections, only: %i[new create]
  end

  resource :cookies, only: %i[show update]
  resource :privacy, as: :privacy, only: :show
  resource :accessibility, only: :show
  resource :help, only: :show
  resources :feature_flags, only: %i[index], path: "feature-flags"
  resources :updates, only: :index
  resources :basic_authentication_sessions, only: %i[new create]
  resources :documents, only: :show

  get "/health", to: "status#health"
  get "/no-analytics", to: "cookies#no_analytics_mode"
  get "instant-:session_type", to: "instant_sessions#create", as: :instant_session
  get "robots.txt", to: "robots#index"
  get "/auth/subdomain_redirect", to: "oauth_redirects#subdomain_redirect", as: :subdomain_redirect
  post "/auth/google/redirect", to: "oauth_redirects#google_redirect", as: :google_oauth_redirect

  authenticate :admin, ->(admin) { admin.persisted? } do
    mount Blazer::Engine, at: "data"
  end

  # Catch and redirect old-format URLs
  get "estimates/:assessment_code/build_estimates/:step", to: "redirects#build_estimate"
  get "estimates/:assessment_code/check_answers/:step", to: "redirects#check_answers"
  put "estimates/:assessment_code/build_estimates/:step", to: "redirects#build_estimate"
  put "estimates/:assessment_code/check_answers/:step", to: "redirects#check_answers"

  get ":step_url_fragment/:assessment_code", to: "build_estimates#show", as: :step
  put ":step_url_fragment/:assessment_code", to: "build_estimates#update"
  get ":step_url_fragment/:assessment_code/check", to: "check_answers#show", as: :check_step
  put ":step_url_fragment/:assessment_code/check", to: "check_answers#update"
end
