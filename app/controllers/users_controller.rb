class UsersController < ApplicationController

  def profile; end

  def update
    if current_user.update(users_params)
      redirect_to profile_users_path, notice: "Your profile update successfully."
    else
      render :profile
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

    user_selected = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    user = User.where.not(id: user_selected.id).where("LOWER(email) = ?", params[:user][:email].downcase)
    render plain: user.empty? ? 'true' : 'false'
  end

  def validate_organisation_without_current_company
    return render plain: false unless params[:user][:company_attributes][:name].present?

    company = Company.where.not(id: current_company.id).where("LOWER(name) = ?", params[:user][:company_attributes][:name].downcase)
    render plain: company.empty? ? 'true' : 'false'
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :logo, :subscribe, company_attributes: [:id, :name, :url])
  end
end