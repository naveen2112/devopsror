class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_company
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end

  def current_company
    @current_company ||= current_user&.company
  end

  helper_method :current_company

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :terms_and_conditions, company_attributes:
      [:name, :url], cards_attributes: [:last_four_digits, :expiry, :stripe_card_id, :token]])
  end
end
