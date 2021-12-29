class UsersController < ApplicationController
  def profile; end

  def update
    if current_user.update(users_params)
      redirect_to profile_users_path, notice: "Your profile update successfully."
    else
      render :profile
    end
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :logo, company_attributes: [:id, :name, :url])
  end
end