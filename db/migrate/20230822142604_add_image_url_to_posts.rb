class AddImageUrlToPosts < ActiveRecord::Migration[7.0]
  def up
    add_column :posts, :image_url, :string, default: "", null: false, after: :content
  end
  def down
    remove_column :posts, :image_url
  end
end
