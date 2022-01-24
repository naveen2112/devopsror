class AddColumnSharedCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :shared_count, :integer, default: 0
  end
end
