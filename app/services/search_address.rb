class SearchAddress
  def self.process(addresses)
    new(addresses).process
  end

  def initialize(addresses)
    @addresses = addresses
    @mappify_client = MappifyClient.new
  end

  def process
    address_data = @addresses.each_with_object([]) do |(address), arr|
      begin
        arr << build_address_from_nlp_address(address)
      rescue => e
        next
      end
    end

    return if address_data.empty?

    Address.import_verified(address_data)
  end

  private

  def build_address_from_nlp_address(address)
    mappify_address = search_address(address.nlp_address)

    confidence = mappify_address[:confidence].round(1)

    [
      *address.attributes.fetch_values("id", "site_id", "nlp_address", "nlp_confidence"),
      *mappify_address[:data].values,
      Address.statuses[:verified],
      confidence
    ]
  end

  def search_address(nlp_address)
    response = @mappify_client.address_search(nlp_address)

    data = transform_data(response['result'].first)

    {
      confidence: response['confidence'],
      data: data
    }
  end

  def transform_data(address_hash)
    street_name = [address_hash['streetName']]
    street_name.push(address_hash['streetType']) if address_hash['streetType']

    {
      street_name: street_name.join(' ').titlecase,
      suburb: address_hash["suburb"].titlecase,
      state: address_hash["state"],
      postcode: address_hash["postCode"],
      lat: address_hash.dig("location", "lat"),
      lng: address_hash.dig("location", "lon")
    }
  end
end
