class ExtractAddresses
  def self.process(sites)
    new.process(sites)
  end

  def process(sites)
    extracted_address_snippets = []

    sites.each do |site|
      site.pages.each do |page|
        extracted = page.extract_address_snippets
        extracted.map! { |address| [page.id, address] }
        extracted_address_snippets.push(*extracted) if extracted.present?
      end
    end

    extracted_address_snippets.uniq! { |snippet| snippet.second }

    content_builders = MLContentBuilder.build_groups(extracted_address_snippets)
    results = nlp_search(content_builders)

    address_data = []

    results.each do |builder, ml_results|
      ml_results.each do |result|
        snippet = builder.find(result["startOffset"].to_i)

        next if snippet.nil?

        address_data << [
          snippet.site_id,
          result["content"],
          result["score"],
          Address.statuses[:nlp],
        ]
      end
    end

    Address.import_nlp(address_data) unless address_data.empty?
  end

  private

  def nlp_search(content_builders)
    ml_client = AutoMLClient.new

    content_builders.each_with_object([]) do |builder, arr|
      # send requests to google cloud ML to extract address entities
      res = ml_client.predict(builder.content)

      payload = res.parsed_response.dig("payload")

      next if !res.success? || payload.nil?

      contents = payload
        .select { |h| h["displayName"] == "address" }
        .each_with_object([]) { |hash, arr|
          content = hash.dig("textExtraction", "textSegment")
          content["score"] = hash.dig("textExtraction", "score")
          arr.push(content)
        }

      arr << [builder, contents]
    end
  end
end
