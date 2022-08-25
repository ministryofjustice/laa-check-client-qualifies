Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  resources :estimates, only: [] do
    resources :build_estimates, only: [:new, :show, :update]
  end

  # resources :pages, only: [:show, :update, :new] do
  #   collection do
  #     get 'home'
  #   end
  # end
end
