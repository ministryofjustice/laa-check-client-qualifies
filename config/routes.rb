Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Currently there is no root path in the application
  # root "pages#home"
  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]

  resources :estimates, only: [:new] do
    resources :build_estimates, only: %i[index show update]
  end

  resource :cookies, only: %i[show update]
end
