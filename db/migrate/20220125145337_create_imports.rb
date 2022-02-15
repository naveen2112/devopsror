class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.references :company, index: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
