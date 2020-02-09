module SnippetExtractor
  extend self

  STATES = [
    "new south wales",
    "queensland",
    "south australia",
    "tasmania",
    "victoria",
    "western australia",
    "nsw",
    "qld",
    "sa",
    "tas",
    "vic",
    "wa",
  ]

  PHONE_REGEX1 = /(\d\d|[(]\d\d[)])\s?\d\d\d\d\s?\d\d\d\d/
  PHONE_REGEX2 = /^(?:\+?61?[- ]|0)[2-478](?:[ -]?[0-9]){8}$/

  def extract(content)
    content_parts = content.to_s
      .downcase
      .gsub(/\P{ASCII}/, "") # remove all non ascii characters
      .split(" ")

    total_size = content_parts.size
    addresses = []

    STATES.each do |state|
      # collect indexes of state positions in content
      indexes = content_parts.map
        .with_index { |word, index| word == state ? index : nil }
        .compact

      next if indexes.empty?

      indexes.each do |index|
        # capture the states surrounding text
        captured = states_surrounding_text(index, total_size, content_parts)

        next if invalid_address?(captured)

        addresses << captured
      end
    end

    addresses
  end

  private

  def invalid_address?(captured)
    captured.blank? || captured.size <= 5 || !captured.match?(/\d\d\d\d/)
  end

  def states_surrounding_text(index, total_size, content_parts)
    lower = calculate_lower_index(index, total_size)
    upper = calculate_upper_index(index, total_size)
    captured = content_parts[lower..upper]

    captured
      .reject { |word| word.include?("@") }
      .join(" ")
      .gsub(/.*address: /, " ") # remove "address: " and anything before it
      .gsub(PHONE_REGEX1, " ")
      .gsub(PHONE_REGEX2, " ")
      .squish
  end

  def calculate_lower_index(index, total_size)
    return index if index.zero?

    distance_from_index = 12
    position = index - distance_from_index

    return 0 if position <= 0
    position
  end

  def calculate_upper_index(index, total_size)
    return total_size if index == total_size

    distance_from_index = 4
    position = index + distance_from_index

    return total_size if position >= total_size
    position
  end
end
