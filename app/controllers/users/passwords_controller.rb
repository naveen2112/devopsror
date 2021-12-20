class Users::PasswordsController < Devise::PasswordsController

  def validate_presence_of_email
    return render plain: false unless params[:user][:email].present?

    user = User.where("LOWER(email) = ?", params[:user][:email].downcase)
    render plain:(user.exists?).to_s
  end
end