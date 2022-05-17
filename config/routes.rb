require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

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

  resources :members, only: [:index, :update, :destroy, :create] do
    member do
      post :confirm
      get :confirm_sign_up
      get :resend_invite
    end
    collection do
      post :import
      get :batch_event
    end
  end

  resources :users, only: [:update] do
    collection do
      put :update_password
      get :profile
      get :unsubscribe
      get :validate_email_without_current_user
      get :validate_organisation_without_current_company
      get :delete_account
    end
  end

  resources :posts do
    member do
      get :send_email_notification
      get :validate_tag
      post :share
      delete :destroy_image
      get :preview_image_from_url
      get :validate_title_except_current
      get :create_tag
      get :company_tag_list
    end
    collection do
      get :validate_title
      get :preview_image_from_url
      get :create_tag
      get :company_tag_list
    end
  end

  resources :billings, only: [:index, :create] do
    collection do
      put :cancel_subscription
    end
    member do
      get :company_tags
    end
  end

  resources :linkedin, only: [] do
    collection do
      get :callback
    end
  end

  get '/analytics' => 'post_user_shares#show'
  get '/shared_details' => 'post_user_shares#shared_details'
  get '/go' => 'posts#track_link_click'

  root "posts#index"
end
