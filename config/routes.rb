Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do
    scope module: "user" do
      root "static_pages#home"
      resources :room_types, only: %i(index show)
      resources :users, only: %i(cancle_request)
      resources :requests, only: %i(update create)  do
        member do
          get :payment
        end
      end
      resources :reviews, only: %i(create)
      get "/profile", to: "users#show"
      get "search", to: "room_types#search"
    end

    namespace :admin do
      get "/", to: "static_pages#home"
      get "/profile", to: "users#show"
      resources :room_types, only: %i(index show)
      resources :rooms, only: %i(index show create update destroy)
      resources :lost_utilities, only: %i(create)
      resources :reviews, only: %i(index) do
        member do
          patch :accept
          patch :reject
        end
      end
      patch "requests/:id/accept", to: "requests#accept", as: "accept_request"
      patch "requests/:id/reject", to: "requests#reject", as: "reject_request"
      resources :requests, only: %i(index show) do
        member do
          patch "send_total_cost"
          patch "update_total_cost"
          patch "payment"
        end
      end
      resources :price_fluctuations, only: %i(index show create update destroy)
    end
    
    devise_for :users, skip: :omniauth_callbacks, controllers: {registrations: "registrations", sessions: "sessions", confirmations: "confirmations"} do
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end

    namespace :api do
      namespace :v1 do
        post "/login", to: "auth#create"
        resources :rooms
      end
    end
  end
end
