class AddColumnCardsCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cards_count, :integer, default: 0
  end
end
