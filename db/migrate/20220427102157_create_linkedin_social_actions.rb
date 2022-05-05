class CreateLinkedinSocialActions < ActiveRecord::Migration[6.1]
  def change
    create_table :linkedin_social_actions do |t|
      t.references :post, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.integer :action_type
      t.integer :platform

      t.timestamps
    end
  end
end
