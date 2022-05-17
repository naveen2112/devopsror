class AddColumnDefaultCardToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :default_card, :boolean, default: true
  end
end
