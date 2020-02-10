class MappifyClient
  include HTTParty

  base_uri "https://mappify.io/api/rpc"

  def initialize(api_key = ENV["MAPPIFY_API_KEY"])
    @api_key = api_key
  end

  def address_search(search)
    options = {
      body: {
        streetAddress: search,
        formatCase: true,
        boostPrefix: false,
        apiKey: @api_key
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }

    self.class.post("/address/autocomplete", options)
  end
end
