Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
  }

  root "pages#home"

  resources :bookings, except: [:index] do
    patch :cancel, on: :member
  end

  resource :profile, only: %i[edit update]

  get "up" => "rails/health#show", as: :rails_health_check
end
