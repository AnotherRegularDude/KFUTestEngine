Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: %i[create]
    resources :users
    resources :topics do
      resources :materials, except: %i[show]
    end
    resources :materials, only: %i[index show]
  end
end
