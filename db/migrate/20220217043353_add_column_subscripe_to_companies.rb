class AddColumnSubscripeToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :plan_type, :integer, default: 0
    add_column :companies, :subscription_status, :integer, default: 0
    add_column :companies, :trail_start_date, :date
    add_column :companies, :trail_end_date, :date
    add_column :companies, :next_billing_date, :date
  end
end
