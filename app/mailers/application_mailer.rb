class ApplicationMailer < ActionMailer::Base
  default from: ENV["DEFAULT_EMAIL_SENDER"]
  layout 'mailer'
  add_template_helper(EmailHelper)
end
