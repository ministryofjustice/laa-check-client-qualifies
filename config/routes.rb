Rails.application.routes.draw do
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show create]
  resource :referrals, only: [:show]

  resources :estimates, only: %i[new create show] do
    resources :build_estimates, only: %i[show update]
    resources :check_answers, only: %i[show update]
    resources :benefits, except: %i[index show] do
      collection { post :add }
    end
    resources :partner_benefits, except: %i[index show] do
      collection { post :add }
    end

    resources :check_benefits_answers, except: %i[index show] do
      collection { post :add }
    end

    resources :check_partner_benefits_answers, except: %i[index show] do
      collection { post :add }
    end

    member { get :print, :check_answers, :download }

    resources :controlled_work_document_selections, only: %i[new create]
  end

  resource :cookies, only: %i[show update]
  resource :privacy, as: :privacy, only: :show
  resource :accessibility, only: :show
  resources :feature_flags, only: :index, path: "feature-flags"

  get "/health-including-dependents", to: "status#health"
  get "/no-analytics", to: "cookies#no_analytics_mode"

  mount Blazer::Engine, at: "data"
end
