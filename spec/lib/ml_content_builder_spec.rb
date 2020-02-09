require "rails_helper"

describe MLContentBuilder do
  describe "offset calculations" do
    subject { MLContentBuilder.new(snippets) }

    let(:snippet_range) { 1..10 }

    let(:snippets) do
      snippet_range.to_a.map do |num|
        no_words = (6..12).to_a.sample
        address = Faker::Lorem.words(no_words).join(" ")

        [num, address]
      end
    end

    describe ".build_groups" do
      let(:snippet_range) { 1..2000 }

      it "group sizes does not exceed #{MLContentBuilder::MAX_GROUP_SIZE} characters" do
        builders = MLContentBuilder.build_groups(snippets)

        builders.each do |builder|
          expect(builder.size).to be <= MLContentBuilder::MAX_GROUP_SIZE
        end
      end
    end

    describe "#content" do
      it "joins snippets with space and full stop" do
        expected_content = snippets.map(&:second).join(". ")
        expect(subject.content).to eq(expected_content)
      end
    end

    describe "#snippets" do
      it "calculates offsets" do
        content_size = 0

        subject.snippets.each do |snippet|
          address_size = snippet.address.size
          content_size += 2 unless content_size.zero?

          expected_end_offset = content_size.zero? ? address_size : content_size + address_size

          expect(snippet.start_offset).to eq(content_size)
          expect(snippet.end_offset).to eq(expected_end_offset - 1)

          content_size += address_size
        end
      end

      it "addresses located at correct offsets" do
        subject.snippets.each_with_index do |snippet, index|
          expected_address = snippets[index].second

          address = subject.content[snippet.start_offset..snippet.end_offset]
          expect(address).to eq(expected_address)
        end
      end
    end

    describe "#find" do
      let(:snippet_range) { 1..500 }

      it "returns the snippet located at position" do
        subject.snippets.each do |snippet|
          start_offset = snippet.start_offset
          end_offset = snippet.end_offset

          expect(subject.find(start_offset)).to eq(snippet)
          expect(subject.find(end_offset)).to eq(snippet)
        end
      end
    end
  end
end
