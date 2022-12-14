Rails.application.routes.draw do
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show create]
  resource :referrals, only: [:show]

  resources :estimates, only: %i[new create] do
    resources :build_estimates, only: %i[index show update]
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

    member { get :print, :check_answers }
  end

  resource :cookies, only: %i[show update]
  resource :privacy, as: :privacy, only: :show
  resource :accessibility, only: :show

  get "/health-including-dependents", to: "status#health"
end
