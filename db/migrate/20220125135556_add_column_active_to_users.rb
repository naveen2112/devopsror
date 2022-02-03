class AddColumnActiveToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invite, :boolean, default: false
    add_column :users, :active, :boolean, default: false
    add_column :users, :login_count, :integer, default: 0
  end
end
