class MembersController < ApplicationController
  load_and_authorize_resource :user, except: [:confirm_sign_up, :confirm]
  skip_before_action :authenticate_user!, only: [:confirm_sign_up, :confirm]
  before_action :set_member, only: [:update, :destroy, :resend_invite, :confirm_sign_up, :confirm]
  before_action :set_admin_users, only: [:batch_event, :destroy] if -> {params["send_invite_email"].blank?}

  def index
    users = current_company.users.includes(:logo_attachment)
    @users = if params[:search].present?
               users.where("email ILIKE :search OR first_name ILIKE :search OR
                                                     last_name ILIKE :search", { search: "%#{params[:search]}%" })
             else
               users
             end
  end

  # Destroy or Send invite email to users select in members page
  def batch_event
    @users = current_company.users.where(id: params[:member_ids])
    if params["send_invite_email"].present?
      @users.each do |user|
        user.send_invite_email
        user.update(invited: true) unless user.invited
      end
      flash[:notice] = "Email invite to the users was sent successfully"
    elsif @admin_users.present?
      @users.destroy_all
    else
      notice = "You must add a Card before deleting a card holder"
    end
    redirect_to members_path, notice: notice
  end

  def confirm_sign_up; end

  def confirm
    if @user.update(confirm_params)
      sign_in(@user, :bypass => true)
      @user.increment!(:login_count)
      redirect_to root_path
    else
      render :confirm_sign_up
    end
  end

  def create
    @user = current_company.users.new(users_params)
    @user.status = "invited" if users_params[:send_invite] == 1
    @user.password = SecureRandom.hex.first(8)

    @user.save
    InstantBillingJob.perform_later(current_company) if current_company.billable?
    redirect_to members_path, notice: "Team member added successfully"
  end

  def resend_invite
    @user.send_invite_email
    @user.update(invited: true) unless @user.invited
    redirect_to members_path, notice: "Email invite to the user was sent successfully"
  end

  def import
    @import = current_company.imports.new(imports_params)

    @import.save
    redirect_to members_path, notice: "Please wait while we process your file. We’ll send you an email updating you on the progress shortly."
  end

  def update
    if @user.update(users_params)
      redirect_to members_path
    else
      redirect_to members_path
    end
  end

  def destroy
    if @admin_users.present? && @user.destroy
      respond_to do |format|
        format.js
      end
    else
      notice = "You must add a Card before deleting a card holder"
    end
    redirect_to members_path, notice: notice
  end

  private

  def set_admin_users
    @admin_users = if @user.present?
                     current_company.users.owner_admin.where.not(id: params[:id])
                   else
                     current_company.users.owner_admin.where.not(id: params[:member_ids])
                   end
  end

  def set_member
    @user = current_company.users.find(params[:id])
  end

  def imports_params
    params.require(:import).permit(:file, :user_id, :invite)
  end

  def confirm_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :accepted)
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :invited)
  end
end
