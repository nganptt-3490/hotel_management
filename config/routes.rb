Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    scope module: "user" do
      root "static_pages#home"
      resources :room_types, only: %i(index show)
      resources :users, only: %i(cancle_request)
      resources :requests, only: %i(update create)  do
        member do
          patch :payment
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
        end
      end
      resources :price_fluctuations, only: :index
    end

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
