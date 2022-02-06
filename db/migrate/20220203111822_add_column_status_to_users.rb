class AddColumnStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invited, :boolean, default: false
  end
end
