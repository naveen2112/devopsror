class ImportMailer < ApplicationMailer

  def import_notification(import, email, total_records_count=nil, error_records_count=nil, headers=nil)
    @status = import.status
    @email = email
    @total_records_count = total_records_count
    @error_records_count = error_records_count
    @headers = headers

    subject = if import.success?
                "Your team members have been successfully imported into SoVocal."
              else
                "Your imported is failed due to some errors"
              end

    attachments['error_list.csv'] = URI.open(import.error_file.url).read if import.failed? && ! headers

    mail to: email, subject: subject
  end

end
