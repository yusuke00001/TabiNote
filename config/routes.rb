Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  get "/homes", to: "homes#index"
  resources :trips do
    member do
      get "suggestion"
      get "vote"
    end
    resources :spots
    resources :spot_suggestions
    resources :spot_votes
    resources :plans
    resources :trip_users do
      member do
        get "change_leader"
      end
    end
  end
  get "/trips/:trip_id/join_page", to: "trip_users#join_page", as: "join_trip_page"
  post "/trips/:trip_id/join", to: "trip_users#create", as: "join_trip"
  post "trip/:id/", to: "trips#decided_plan", as: "trip_decided_plan"

  root "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
