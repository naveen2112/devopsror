class AddColumnSubscribeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscribe, :boolean, default: true
  end
end
