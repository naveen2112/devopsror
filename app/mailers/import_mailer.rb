class ImportMailer < ApplicationMailer

  def import_notification(import, imported_user, total_records_count=nil, error_records_count=nil, headers=nil)
    @status = import.status
    @user = imported_user
    @total_records_count = total_records_count
    @error_records_count = error_records_count
    @headers = headers

    subject = if import.success?
                "Your team members have been successfully imported into SoVocal."
              else
                "Your imported is failed due to some errors"
              end

    attachments['error_list.csv'] = URI.open(import.error_file.url).read if import.failed? && ! headers

    mail from: "#{import.company.name.capitalize}(via SoVocal)  <#{ENV["DEFAULT_EMAIL_SENDER"]}>", to: imported_user.email, subject: subject
  end

end
