class AddColumnActiveToUsers < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :users, :terms_and_condition }

    add_column :users, :invite, :boolean, default: false
    add_column :users, :active, :boolean, default: false
    add_column :users, :login_count, :integer, default: 0
  end
end
