class UsersController < ApplicationController

  def profile; end

  def update
    if current_user.update(users_params.compact_blank)
      redirect_to profile_users_path, notice: "Your profile update successfully."
    else
      render :profile
    end
  end

  def update_password
    if current_user.valid_password?(password_params[:current_password])
      current_user.update(password_params)
      sign_in(current_user, :bypass => true)
      redirect_to profile_users_path, notice: "Your password update successfully."
    else
      redirect_to profile_users_path, alert: "Invalid current password."
    end
  end

  def delete_account
    current_user.integrated_accounts.with_platform("linked_in").destroy_all
  end

  def unsubscribe
    current_user.update(subscribe: false)
    redirect_to posts_path
  end

  def validate_email_without_current_user
    return render plain: false unless params[:user][:email].present?

    # While updating we need to remove the validation for that user
    user_selected = if params[:user_id].present?
                      User.find(params[:user_id])
                    else
                      current_user
                    end
    user = current_company.users.where("LOWER(email) = ?", params[:user][:email].downcase).where.not(id: user_selected.id)
    render plain: user.empty? ? 'true' : 'false'
  end

  def validate_organisation_without_current_company
    return render plain: false unless params[:user][:company_attributes][:name].present?

    company = Company.where.not(id: current_company.id).where("LOWER(name) = ?", params[:user][:company_attributes][:name].downcase)
    render plain: company.empty? ? 'true' : 'false'
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :logo, :subscribe, :password, :password_confirmation,
                                 :current_password, company_attributes: [:id, :name, :url])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end