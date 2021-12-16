class AddColumnStripeCustomerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :terms_and_conditions, :boolean, default: false
  end
end
