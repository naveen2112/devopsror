class ImportMailer < ApplicationMailer

  def import_notification(import, email, total_records_count=nil, error_records_count=nil)
    @status = import.status
    @email = email
    @total_records_count = total_records_count
    @error_records_count = error_records_count

    attachments['error_list.csv'] = URI.open(import.error_file.url).read if import.failed?

    mail to: email, subject: "Import progress"
  end

end
