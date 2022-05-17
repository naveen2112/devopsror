class CreatePostUserShares < ActiveRecord::Migration[6.1]
  def change
    create_table :post_user_shares do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :share_id
      t.integer :engagement_count, default: 0

      t.timestamps
    end
  end
end
