class AddColumnUserIdToImport < ActiveRecord::Migration[6.1]
  def change
    add_column :imports, :user_id, :integer
  end
end
