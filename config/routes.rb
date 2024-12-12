Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :product_ingredients, only: %i[index]
      resources :recipes, only: %i[index]
    end
  end
  root 'homepage#index'
  get '/*path' => 'homepage#index'
end
