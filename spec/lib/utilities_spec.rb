require "rails_helper"

describe Utilities do
  describe ".html_to_string" do
    subject { Utilities.html_to_string(html) }
    let(:html) { nil }

    context "when string contains html" do
      let(:html) { "<html><p>#{content}</p></html>" }
      let(:content) { "some content" }

      it "returns string without html" do
        expect(subject).to eq(content)
      end
    end

    context "when string contains line endings" do
      subject { Utilities.html_to_string(html) }
      let(:html) { "\nso\n\n\nme\nsdfdf sdfdsf\n sdfdsfa" }

      it "returns string without line endings" do
        expect(subject).to_not include("\n")
      end
    end

    context "when string contains recurring spaces" do
      subject { Utilities.html_to_string(html) }
      let(:html) { "the     quick brown  fox" }

      it "returns string without recurring spaces" do
        expect(subject).to eq("the quick brown fox")
      end
    end

    context "when string contains return characters" do
      subject { Utilities.html_to_string(html) }
      let(:html) { "Newcastle | Sydney\\\\n\\\\n\\\\n Website \\\\n \\\\n \\\\n \\\\n \\\\n staff \\\\n \\\\n\\\\n\\\\n \\\\n" }

      it "returns a string without the return characters and forward slashes" do
        expect(subject).to eq("Newcastle | Sydney Website staff")
      end
    end

    context "with string contains tab characters" do
      subject { Utilities.html_to_string(html) }
      let(:html) { "Criminal Law\\n\\t\\t\\t\\t\\t\\t\\t<h3>\tCommercial Law" }

      it "returns a string without tab characters" do
        expect(subject).to eq("Criminal Law Commercial Law")
      end
    end

    context "when string contains html entities" do
      subject { Utilities.html_to_string(html) }
      let(:entities) { ["&nbsp;", "&lt;", "&gt;", "&amp;", "&quot;", "&cent;", "&pound;", "&yen;", "&euro;", "&copy;", "&reg;"].join("") }
      let(:html) { "<html>extract #{entities} me #{entities}</html>" }

      it "removes all html entities" do
        expect(subject).to eq("extract me")
      end
    end
  end
end
