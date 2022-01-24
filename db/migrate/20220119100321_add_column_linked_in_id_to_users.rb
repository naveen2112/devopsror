class AddColumnLinkedInIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :linked_in_id, :string
  end
end
