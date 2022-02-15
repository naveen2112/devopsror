class AddIndexEmailCompanyIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, [:email, :company_id], unique: true
  end
end
