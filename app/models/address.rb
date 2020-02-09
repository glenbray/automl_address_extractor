class Address < ApplicationRecord
  enum status: { extracted: 0, nlp: 1, verified: 2 }

  belongs_to :page

  def self.import_nlp(address_data)
    Address.import(
      [:page_id, :nlp_address, :nlp_confidence, :status],
      address_data,
      validate: false,
      on_duplicate_key_ignore: true
    )
  end
end
