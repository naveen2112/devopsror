class ImportMailer < ApplicationMailer

  def send_import_email(import, email)
    @status = import.status
    @email = email

    attachments['error_list.csv'] = URI.open(import.error_file.url).read if import.failed?

    mail to: email, subject: "Import progress"
  end

end
