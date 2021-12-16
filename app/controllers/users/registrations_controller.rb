class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    response = Stripe::Customer.create(email: resource.email, card: resource.cards&.first&.token)
    resource.update(stripe_customer_id: response.id)
  end

  def validate_email
    return render plain: false unless params[:user][:email].present?

    user = User.where("LOWER(email) = ?", params[:user][:email].downcase)
    render plain: user.empty? ? 'true' : 'false'
  end

  def validate_organisation
    return render plain: false unless params[:user][:company_attributes][:name].present?

    company = Company.where("LOWER(name) = ?", params[:user][:company_attributes][:name].downcase)
    render plain: company.empty? ? 'true' : 'false'
  end
end