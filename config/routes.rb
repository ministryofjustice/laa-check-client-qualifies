Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  devise_for :admins, :providers,
             skip: %i[sessions controllers]
  devise_scope :admin do
    get "/auth/google_oauth2/callback" => "admins/omniauth_callbacks#google_oauth2", as: :admin_google_oauth2_omniauth_callback
    get "/admins/sign_in" => "admins/sessions#new", as: :new_admin_session
  end

  devise_scope :provider do
    get "/providers/sign_in" => "providers/sessions#new", as: :new_provider_session
    post "/providers/sign_in" => "providers/sessions#create", as: :provider_session
    get "/providers/sign_out", to: "providers/sessions#destroy", as: :providers_logout

    # get callback only happens during tests - real IDP (SAML 2.0) only uses POST
    match "/providers/auth/saml/callback" => "providers/omniauth_callbacks#saml", via: %i[get post], as: :provider_saml_omniauth_callback
  end

  # dummy secured endpoint for testing
  resources :provider_secrets, only: [:index]

  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]

  resource :cookies, only: %i[show update]
  resource :privacy, as: :privacy, only: :show
  resource :accessibility, only: :show
  resource :help, only: :show
  resources :feature_flags, only: %i[index], path: "feature-flags"
  resources :updates, only: :index
  resources :basic_authentication_sessions, only: %i[new create]
  resources :documents, only: :show
  resources :feedbacks, only: %i[create update]

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
  get "estimates/:assessment_code/check_answers/:step", to: "redirects#check"
  put "estimates/:assessment_code/build_estimates/:step", to: "redirects#build_estimate"
  put "estimates/:assessment_code/check_answers/:step", to: "redirects#check"
  get "estimates/:assessment_code/check_answers", to: "redirects#check_answers"
  get "estimates/:assessment_code", to: "redirects#result"
  get "estimates/:assessment_code/print", to: "redirects#result"
  get "estimates/:assessment_code/download", to: "redirects#result"
  get "estimates/:assessment_code/check_answers", to: "redirects#check_answers"
  get "estimates/:assessment_code/controlled_work_document_selections/new", to: "redirects#cw_forms"
  post "estimates/:assessment_code/controlled_work_document_selections", to: "redirects#cw_forms"
  get "download-cw-form/:assessment_code", to: "redirects#cw_forms"
  post "download-cw-form/:assessment_code", to: "redirects#cw_forms"
  get "which-controlled-work-form/:assessment_code", to: "redirects#cw_forms"
  post "which-controlled-work-form/:assessment_code", to: "redirects#cw_forms"
  get "provider_users", to: redirect("/new-check")
  get "do-you-give-legal-advice-or-provide-legal-services", to: redirect("/new-check")
  get "/print/:assessment_code", to: "results#download"

  get "new-check", to: "checks#new", as: :new_check
  get "check-answers/:assessment_code", to: "checks#check_answers", as: :check_answers
  get "service-end/:assessment_code", to: "checks#end_of_journey", as: :end_of_journey

  get "/download/:assessment_code", to: "results#download", as: :download_result
  get "/cw-form/:assessment_code", to: "controlled_work_document_selections#download", as: :download_cw_form

  get "select-cw-form/:assessment_code", to: "controlled_work_document_selections#new", as: :controlled_work_document_selection
  post "select-cw-form/:assessment_code", to: "controlled_work_document_selections#create"

  get "check-result/:assessment_code", to: "results#show", as: :result
  post "check-result/:assessment_code", to: "results#create"

  get ":step_url_fragment/:assessment_code", to: "forms#show", as: :step
  put ":step_url_fragment/:assessment_code", to: "forms#update"
  get ":step_url_fragment/:assessment_code/check", to: "change_answers#show", as: :check_step
  put ":step_url_fragment/:assessment_code/check", to: "change_answers#update"
end
