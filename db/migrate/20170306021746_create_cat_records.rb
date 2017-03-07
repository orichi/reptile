class CreateCatRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :cat_records do |t|
      t.string :name
      t.string :link
      t.integer :count
      t.string :paginate_link
      t.integer :pages_count
      t.timestamps
    end

    add_index :cat_records, :name, :unique => true
  end
end
