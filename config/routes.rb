require 'sidekiq/web'

Rails.application.routes.draw do

  # Pg engines routes
  mount PgHero::Engine, at: "pghero"

  # Sidekiq activities
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: "users/registrations",
                                    passwords: "users/passwords"}

  devise_scope :user do
    get "users/validate_email", to: "users/registrations#validate_email"
    get "users/validate_organisation", to: "users/registrations#validate_organisation"
    get "users/validate_presence_of_email", to: "users/passwords#validate_presence_of_email"
  end

  resources :users, only: [:update] do
    collection do
      get :profile
      get :validate_email_without_current_user
      get :validate_organisation_without_current_company
    end
  end

  resources :posts

  root "posts#index"
end
