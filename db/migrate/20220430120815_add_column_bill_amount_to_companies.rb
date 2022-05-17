class AddColumnBillAmountToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :charged_amount, :float, default: 0.0
  end
end
