class AddColumnToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :billing_type, :integer, default: 0
  end
end
