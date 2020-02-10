class Address < ApplicationRecord
  enum status: {extracted: 0, nlp: 1, verified: 2}

  belongs_to :site

  def self.import_nlp(address_data)
    Address.import(
      [:site_id, :nlp_address, :nlp_confidence, :status],
      address_data,
      validate: false,
      on_duplicate_key_ignore: true
    )
  end

  def self.import_verified(address_data)
    fields = [
      :id,
      :site_id,
      :nlp_address,
      :nlp_confidence,
      :street_name,
      :suburb,
      :state,
      :postcode,
      :lat,
      :lng,
      :status,
      :mappify_confidence
    ]

    Address.import(
      fields,
      address_data,
      validate: false,
      on_duplicate_key_update: { conflict_target: [:id], columns: fields - [:id] }
    )
  end
end
