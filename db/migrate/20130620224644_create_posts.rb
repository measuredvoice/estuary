class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :published_at
      t.string :service
      t.string :id_on_service
      t.string :title
      t.text :description
      t.text :image_url
      t.text :permalink_url
      t.integer :account_id

      t.timestamps
    end
    
    add_index :posts, [:service, :id_on_service]
  end
end
