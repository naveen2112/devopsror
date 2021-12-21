class CreateCommentries < ActiveRecord::Migration[6.1]
  def change
    create_table :commentries do |t|
      t.references :post, index: true
      t.text :description

      t.timestamps
    end
  end
end
