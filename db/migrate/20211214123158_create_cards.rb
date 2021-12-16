class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.references :user, index: true
      t.string :number
      t.integer :cvv
      t.string :expiry
      t.string :card_id
      t.string :token

      t.timestamps
    end
  end
end
