Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: %i[create]

    resources :users
    resources :topics
  end
end
