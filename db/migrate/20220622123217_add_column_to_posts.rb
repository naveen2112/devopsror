class AddColumnToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :preview_url_title, :string
  end
end
