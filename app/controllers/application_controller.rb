class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :terms_and_conditions, company_attributes:
        [:name], cards_attributes: [:last_four_digits, :expiry, :stripe_card_id, :token]])
  end
end
