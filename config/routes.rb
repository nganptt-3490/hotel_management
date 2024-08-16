Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    scope module: "user" do
      root "static_pages#home"
      resources :room_types, only: %i(index show)
    end

    namespace :admin do
      get "/", to: "static_pages#home"
    end
  end
end
