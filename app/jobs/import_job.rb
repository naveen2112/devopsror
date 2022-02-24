require 'csv'
require 'open-uri'

class ImportJob < ApplicationJob
  queue_as :default

  def perform(id, company_id, user_id)
    import = Import.find(id)
    company = Company.find(company_id)
    imported_user = company.users.find(user_id)
    if company.sales_led?
      if (company.users.count + get_data(import).count) >= company.user_limit
        ImportMailer.import_notification(import, imported_user, nil, nil, nil, true).deliver_later
      else
        process_import(import, company, imported_user)
      end
    else
      process_import(import, company, imported_user)
    end
  end

  def process_import(import, company, imported_user)
    headers = csv_headers(import)
    if headers.compact&.sort == ["firstname", "lastname", "email", "role"].sort
      users_data = get_data(import)

      errors_data = []
      users_data.each do |user|
        begin
          current_user = company.users.new(first_name: user["firstname"], last_name: user["lastname"],
                                           email: user["email"], role: user["role"].downcase,
                                           password: SecureRandom.hex.first(8), invited: import.invite)
          errors_data << user.merge(reason: current_user.errors.full_messages.join(", ")) unless current_user.save
        rescue ActiveRecord::RecordNotUnique => e
          errors_data << user.merge(reason: "Email already taken.")
        end
      end

      if errors_data.size == 0
        import.update(status: "success")
        ImportMailer.import_notification(import, imported_user).deliver_later
      else
        create_error_csv_from_hash(errors_data, import, imported_user, users_data.count)
      end
    else
      import.update(status: "failed")
      ImportMailer.import_notification(import, email, nil, nil, true).deliver_later
    end
  end

  # creates and error csv file from the attributes and deliver it attach it the import
  def create_error_csv_from_hash(error_list, import, imported_user, total_records_count)
    tmp_file = Rails.root.join('tmp', "#{SecureRandom.alphanumeric(10)}.csv")

    CSV.open(tmp_file, "wb") do |csv|
      csv << error_list.first.keys # adds the attributes name on the first line
      error_list.each do |hash|
        csv << hash.values
      end
    end

    import.error_file.attach(io: File.open(tmp_file), filename: 'error_list.csv', content_type: 'text/csv')
    import.status = total_records_count == error_list.count ? "failed" : "success"
    import.save
    ImportMailer.import_notification(import, imported_user, total_records_count, error_list.count).deliver_later

    File.delete tmp_file if File.exists? tmp_file
  end

  def get_data(import)
    users = []
    CSV.parse(URI.open(import.file.url), headers: true, skip_blanks: true) do |row|
      clean_row = row.delete_if { |header, _field| header.nil? }
      users << clean_row.to_hash
    end

    users
  end

  def csv_headers(import)
    CSV.parse(URI.open(import.file.url), headers: true, skip_blanks: true).headers
  end
end