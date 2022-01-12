class AddColumnCreatedByToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :created_by, :integer
  end
end
