class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.references :site, null: false, foreign_key: true
      t.string :page_url
      t.string :html
      t.string :content

      t.timestamps
    end
  end
end
