# frozen_string_literal: true

module Utilities
  class << self
    def html_to_string(original_html)
      html = original_html.dup
      html_entities = ["&#13;", "&nbsp;", "&lt;", "&gt;", "&amp;", "&quot;", "&cent;", "&pound;", "&yen;", "&euro;", "&copy;", "&reg;"]
      html_entities.each { |entity| html.gsub!(entity, " ") }

      doc = Nokogiri::HTML(html)

      doc.xpath("//text()").each do |node|
        content = node.content
        node.remove if content.size > 500 && valid_json?(content)
      end

      text = doc.text
      text.gsub!("\\n", " ")
      text.tr!("\n", " ")
      text.gsub!("\\t", " ")
      text.tr!("\t", " ")
      text.gsub!(/\P{ASCII}/, " ")
      text.tr!("\\", " ")

      text.squish
    end

    def valid_json?(json)
      JSON.parse(json)
      true
    rescue JSON::ParserError => e
      false
    end
  end
end
