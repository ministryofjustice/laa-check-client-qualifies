Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Currently there is no root path in the application
  # root "pages#home"

  resources :estimates, only: [] do
    resources :build_estimates, only: [:new, :show, :update]
  end
end
