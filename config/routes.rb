Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Currently there is no root path in the application
  # root "pages#home"
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show update]
  resource :referrals, only: [:show]

  resources :estimates, only: [:new] do
    resources :build_estimates, only: %i[index show update]
  end
end
