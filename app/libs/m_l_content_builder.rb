class MLContentBuilder
  MAX_GROUP_SIZE = 10_000
  Snippet = Struct.new(:page_id, :address, :start_offset, :end_offset)

  attr_reader :snippets, :content

  def self.build_groups(snippets, max_group_size = MAX_GROUP_SIZE)
    grouped = snippets.each_with_object([]) { |snippet, arr|
      snippet_group = arr.pop || []

      content_size = snippet.second.size
      snippet_group_content_size = snippet_group.sum { |group| group.second.size }

      # calculate the space and full stop characters counts between each snippet
      join_size = 0
      join_size = snippet_group.size * 2 if snippet_group.size > 0

      group_size = snippet_group_content_size + content_size + join_size

      if group_size <= max_group_size
        snippet_group.push(snippet)
        arr << snippet_group
      else
        arr << snippet_group
        arr << [snippet]
      end
    }

    grouped.map! { |group| new(group) }
  end

  def initialize(snippets)
    @snippets = snippets.map { |snippet| Snippet.new(*snippet) }
    build_content_and_calculate_offsets
  end

  def find(position)
    @snippets.find { |s| position.between?(s.start_offset, s.end_offset) }
  end

  def size
    content.size
  end

  private

  def build_content_and_calculate_offsets
    content = []

    @snippets.each_with_index do |snippet, index|
      content.push(snippet.address)

      address_length = snippet.address.length - 1

      if content.size == 1
        snippet.start_offset = 0
        snippet.end_offset = address_length
      else
        prev_snippet = @snippets[index - 1]
        prev_end_offset = prev_snippet.end_offset + 3

        snippet.start_offset = prev_end_offset
        snippet.end_offset = prev_end_offset + address_length
      end
    end

    @content = content.join(". ")
  end
end
