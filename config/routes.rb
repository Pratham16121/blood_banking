Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#index'
  resources :users, only: [ :index, :create ] do 
    collection do
      post 'login'
      get 'new', as: 'new'
      get 'search'
      get 'logout'
    end
  end
  resources :blood_requests, only: [ :index, :create, :update ] do
    collection do
      get 'new', as: 'new'
    end
  end
  resources :blood_banks, only: [ :index, :create ] do
    collection do
      get 'new', as: 'new'
    end
  end
  resources :donations, only: [ :create ] do
    collection do
      get 'new', as: 'new'
    end
  end
end
