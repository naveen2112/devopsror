class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :company, index: true
      t.string :title
      t.text :platform_name, array: true, default: []
      t.string :main_url
      t.boolean :notification, default: false
      t.integer :status, default: 0


      t.timestamps
    end
  end
end
