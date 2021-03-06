Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get "/settings" => "pages#settings"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # /api/v1/restaurants
      resources :candidates, only: [ :index, :show, :update, :create, :destroy ]
    end
  end
  	resources :candidates, only: [ :index, :show ]
end