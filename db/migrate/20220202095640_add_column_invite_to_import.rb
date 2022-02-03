class AddColumnInviteToImport < ActiveRecord::Migration[6.1]
  def change
    add_column :imports, :invite, :boolean, default: false
  end
end
