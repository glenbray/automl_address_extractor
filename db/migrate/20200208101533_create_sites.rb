class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :url
      t.integer :pages_count

      t.timestamps
    end

    add_index :sites, :url
  end
end
