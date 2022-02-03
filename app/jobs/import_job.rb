require 'csv'
require 'open-uri'

class ImportJob < ApplicationJob
  queue_as :default

  def perform(id, company_id, email)
    import = Import.find(id)
    company = Company.find(company_id)
    users_data = get_data(import)

    errors_data = []
    users_data.each do |user|
      current_user = company.users.new(first_name: user["firstname"], last_name: user["lastname"],
                                       email: user["email"], role: user["role"].downcase,
                                       password: SecureRandom.hex.first(8), invite: import.invite)
      errors_data << user.merge(reason: current_user.errors.full_messages.join(", "))  unless current_user.save
    end

    if errors_data.size == 0
      import.update(status: "success")
      ImportMailer.send_import_email(import, email).deliver_later
    else
      create_error_csv_from_hash(errors_data, import, email)
    end
  end

  # creates and error csv file from the attributes and deliver it attach it the import
  def create_error_csv_from_hash(error_list, import, email)
    tmp_file = Rails.root.join('tmp', "#{SecureRandom.alphanumeric(10)}.csv")

    CSV.open(tmp_file, "wb") do |csv|
      csv << error_list.first.keys # adds the attributes name on the first line
      error_list.each do |hash|
        csv << hash.values
      end
    end


    import.error_file.attach(io: File.open(tmp_file), filename: 'error_list.csv', content_type: 'text/csv')
    import.status = "failed"
    import.save
    ImportMailer.send_import_email(import, "kishore@gmail.com").deliver_later

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
end