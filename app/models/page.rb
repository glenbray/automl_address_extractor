class Page < ApplicationRecord
  belongs_to :site, counter_cache: true

  def extract_address_snippets
    SnippetExtractor.extract(content)
  end
end
