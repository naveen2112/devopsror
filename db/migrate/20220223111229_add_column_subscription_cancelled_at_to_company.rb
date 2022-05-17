class AddColumnSubscriptionCancelledAtToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :subscription_cancelled_at, :date
  end
end
