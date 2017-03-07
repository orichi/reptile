class CreateProdRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :prod_records do |t|
      t.string :j_id
      t.string :name
      t.decimal :price
      t.string :spec
      t.string :link
      t.string :cat_link
      t.integer :cat_page
      t.text :desc
      t.string :version
      t.integer :cat_record_id
      t.timestamps
    end

    add_index :prod_records, :name
    add_index :prod_records, :j_id, :unique => true
  end
end
