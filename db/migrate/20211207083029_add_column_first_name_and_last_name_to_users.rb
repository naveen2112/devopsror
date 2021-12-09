class AddColumnFirstNameAndLastNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :terms_and_condition, :boolean, default: false
    add_column :users, :role, :integer, default: 0
  end
end
