Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: "start#index"

  resources :start, only: [:index]
  resources :status, only: [:index]
  resource :provider_users, only: %i[show create]
  resource :referrals, only: [:show]

  resources :estimates, only: %i[new create] do
    resources :build_estimates, only: %i[index show update] do
      resources :applicant_case_details, only: %i[index show update]
      resources :incomes, only: %i[index show update]
      resources :capitals, only: %i[index show update] do
        resources :properties, only: %i[index show update]
        resources :vehicles, only: %i[index show update]
      end
    end
    resources :check_answers, only: %i[show update]
  end

  resource :cookies, only: %i[show update]
end
