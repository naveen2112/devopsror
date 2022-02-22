class AddColumnCompanyIdToIntegratedAccounts < ActiveRecord::Migration[6.1]
  def change
    add_reference :integrated_accounts, :company, index: true
  end
end
