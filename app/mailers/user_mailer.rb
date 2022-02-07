class UserMailer < ApplicationMailer
  def invite_email(company_id, user_id)
    company = Company.find(company_id)
    @user = company.users.find(user_id)

    mail to: @user.email, subject: "Join #{company.name} on SoVocal"
  end
end