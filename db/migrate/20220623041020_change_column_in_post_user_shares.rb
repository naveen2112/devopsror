class ChangeColumnInPostUserShares < ActiveRecord::Migration[6.1]
  def up
    add_column :post_user_shares, :likes_count, :integer, default:0
    add_column :post_user_shares, :comments_count, :integer, default: 0
    add_column :post_user_shares, :reach_count, :integer, default: 0
  end

  def down
    remove_column :post_user_shares, :engagement_count, :integer
  end
end
