class Users::RegistrationsController < Devise::RegistrationsController
  rescue_from Stripe::CardError do |e|
    redirect_to new_user_registration_path, alert: e.message
  end

  def create
    User.transaction do
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        response = Stripe::Customer.create(email: resource.email, card: resource.cards&.first&.token)
        resource.update(stripe_customer_id: response.id)
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
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