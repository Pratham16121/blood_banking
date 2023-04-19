Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  api_version(:module => "Api::V1", :header => {
    name: "Accept", :value => "application/vnd.blood_banking; version=1"}) do
      resources :users, only: [ :index, :create ] do 
        collection do
          post 'login'
        end
      end
  end
end
