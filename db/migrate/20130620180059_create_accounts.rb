class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :service
      t.string :name_on_service
      t.string :id_on_service
      t.string :url
      t.text :tags
      t.boolean :active

      t.timestamps
    end
    
    add_index :accounts, [:service, :id_on_service, :active]
    add_index :accounts, [:url]
  end
end

