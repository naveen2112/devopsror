Rails.application.routes.draw do

  # Pg engines routes
  mount PgHero::Engine, at: "pghero"

  devise_for :users, controllers: { registrations: "users/registrations" }

  devise_scope :user do
    get "users/validate_email", to: "users/registrations#validate_email"
    get "users/validate_organisation", to: "users/registrations#validate_organisation"
  end

  root "posts#index"
end
