class AddColumnAcceptedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :accepted, :boolean, default: false
  end
end
