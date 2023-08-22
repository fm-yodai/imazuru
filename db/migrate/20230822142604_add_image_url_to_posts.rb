class AddImageUrlToPosts < ActiveRecord::Migration[7.0]
  def up
    add_column :posts, :image_url, :string, limit: 1000, default: "", null: false, after: :content
    add_column :posts, :prompt, :string, limit: 1000, default: "", null: false, after: :image_url
  end
  def down
    remove_column :posts, :image_url
    remove_column :posts, :prompt
  end
end
