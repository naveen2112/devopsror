class AddColumnUserLimitToOrganisations < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :user_limit, :integer, default: 20
  end
end
