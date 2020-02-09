class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :page, null: false, foreign_key: true
      t.string :street_no
      t.string :street_name
      t.string :suburb
      t.string :state
      t.string :postcode
      t.decimal :lat
      t.decimal :lng
      t.integer :status
      t.string :nlp_address
      t.decimal :nlp_confidence
      t.decimal :mappify_confidence

      t.timestamps
    end
  end
end
