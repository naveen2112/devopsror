require 'csv'
require 'open-uri'

class ImportJob < ApplicationJob
  queue_as :default

  def perform(id, company_id)
    import = Import.find(id)
    company = Company.find(company_id)
    users_data = get_data(import)

    errors_data = []
    users_data.each do |user|
      current_user = company.users.new(first_name: user["firstname"], last_name: user["lastname"], email: user["email"], role: user["role"])
      errors_data << user  unless current_user.save
    end

    if errors_data.size == 0
      import.update(status: "success")
    else
      import.update(status: "failed")
    end
  end

  def get_data(import)
    users = []
    CSV.foreach(URI.open(import.file.url), headers: true, skip_blanks: true) do |row|
      clean_row = row.delete_if { |header, _field| header.nil? }
      users << clean_row.to_hash
    end

    users
  end
end