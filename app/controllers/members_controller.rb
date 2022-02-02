class MembersController < ApplicationController
  load_and_authorize_resource :user
  before_action :set_company, only: [:confirm_sign_up, :confirm]
  before_action :set_user, only: [:confirm_sign_up, :confirm]
  skip_before_action :authenticate_user!, only: [:confirm_sign_up, :confirm]
  before_action :set_member, only: [:update, :destroy, :resend_invite]

  def index
    users = current_company.users.includes(:logo_attachment)
    @users = params[:search].present? ? users.where("email ILIKE :search OR first_name ILIKE :search OR
                                                     last_name ILIKE :search", {search: "%#{params[:search]}%"}) : users
  end

  def batch_event
    @users = current_company.users.where(id: params[:member_ids])
    if params["send_invite_email"].present?
      @users.each do |user|
        user.send_invite_email
        user.update(invite: true)
      end
    else
      @users.destroy_all
    end
    redirect_to members_path
  end

  def confirm_sign_up; end

  def confirm
    if @user.update(confirm_params)
      redirect_to root_path
    else
      render :confirm_sign_up
    end
  end

  def create
    @user = current_company.users.new(users_params)
    @user.password = SecureRandom.hex.first(8)

    @user.save
    redirect_to members_path
  end

  def resend_invite
    @user.send_invite_email
    @user.update(invite: true)
    redirect_to members_path
  end

  def import
    @import = current_company.imports.new(imports_params)

    @import.save
    redirect_to members_path
  end

  def update
    if @user.update(users_params)
      redirect_to members_path, notice: "Member updated Successfully."
    else
      redirect_to members_path, alert: "Something went wrong, please try later."
    end
  end

  def destroy
    if @user.destroy
      respond_to do |format|
        format.js
      end
    else
      redirect_to posts_path, alert: "Something went wrong, please try later."
    end
  end

  private

  def set_member
    @user = current_company.users.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_user
    @user = @company.users.find(params[:id])
  end

  def imports_params
    params.require(:import).permit(:file, :user_id, :invite)
  end

    def confirm_params
      params.require(:user).permit(:password, :password_confirmation)
    end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :invite)
  end
end
