class CreateIntegratedAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :integrated_accounts do |t|
      t.references :user, index: true
      t.integer :platform
      t.jsonb :data

      t.timestamps
    end
  end
end
