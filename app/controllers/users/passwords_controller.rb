class Users::PasswordsController < Devise::PasswordsController

  def validate_user_email
    return render plain: false unless params[:user][:email].present?

    user = User.where("LOWER(email) = ?", params[:user][:email].downcase)
    render plain: user.empty? ? 'false' : 'true'
  end
end