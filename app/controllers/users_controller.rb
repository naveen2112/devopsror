# frozen_string_literal: true

class UsersController < ApplicationController

  # GET /users/profile
  def profile; end

  # PUT /users/:id
  def update
    if current_user.update(users_params)
      redirect_to profile_users_path, notice: "Your profile update successfully."
    else
      render :profile
    end
  end

  # GET /users/unsubscribe
  def unsubscribe
    current_user.update(subscribe: false)
    redirect_to posts_path
  end

  # GET /users/validate_email_without_current_user
  def validate_email_without_current_user
    return render plain: false unless params[:user][:email].present?

    user = User.where.not(id: current_user.id).where("LOWER(email) = ?", params[:user][:email].downcase)
    render plain: user.empty? ? 'true' : 'false'
  end

  # GET /users/validate_organisation_without_current_company
  def validate_organisation_without_current_company
    return render plain: false unless params[:user][:company_attributes][:name].present?

    company = Company.where.not(id: current_company.id).where("LOWER(name) = ?", params[:user][:company_attributes][:name].downcase)
    render plain: company.empty? ? 'true' : 'false'
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :logo, company_attributes: [:id, :name, :url])
  end
end