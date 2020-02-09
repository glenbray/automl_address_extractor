require "rails_helper"

describe SnippetExtractor do
  describe ".extract" do
    subject { SnippetExtractor.extract(content) }

    context "when an empty string is provided" do
      let(:content) { "" }

      it { is_expected.to be_empty }
    end

    context "when nil is provided" do
      let(:content) { nil }

      it { is_expected.to be_empty }
    end

    context 'removes "address:" and characters before' do
      let(:content) { "9763 5833 address: 11-21 underwood rd, homebush nsw 2140 name * name" }

      it { is_expected.to match_array(["11-21 underwood rd, homebush nsw 2140 name * name"]) }
    end

    context "removes phone numbers" do
      let(:content) { "02 95237292 bar (02) 95270807 bistro 49 liverpool street, bundeena nsw 2021 recent posts" }
      let(:expected) { ["bar bistro 49 liverpool street, bundeena nsw 2021 recent posts"] }

      it { is_expected.to match_array(expected) }
    end

    context "removes 1300 phone numbers" do
      let(:content) { "1300232231 some other nsw 2000 words" }
      let(:expected) { ["some other nsw 2000 words"] }

      it { is_expected.to match_array(expected) }
    end

    context "when string contains @" do
      let(:content) { "@twitter email@gmail.com some other nsw 2000 words" }
      let(:expected) { ["some other nsw 2000 words"] }

      it { is_expected.to match_array(expected) }
    end

    context "string contains multiple addresses" do
      let(:content) do
        <<~CONTENT
          PW Podiatry Home About Services Children's Feet Diabetes Foot Care
          Foot Mobilisation Fungal Toenails General Foot Care Ingrown Toenails
          Orthotics Prolotherapy Injections Sports Injuries
          Blog Contact Us BOOK ONLINE NOW Home About Services Children's Feet
          Diabetes Foot Care Foot Mobilisation Fungal Toenails General Foot Care
          Ingrown Toenails Orthotics Prolotherapy Injections Sports Injuries
          Blog Contact Us BOOK ONLINE NOW Welcome PW Podiatry is a podiatry
          clinic servicing the Pakenham, Koo Wee Rup &amp; East Bentleigh areas.
          Come and see us so that we can effectively diagnose, treat and
          rehabilitate your foot and lower limb problems. View our list of
          services below and make an appointment as soon as possible to get your
          feet healthy again. Back to Top hello@pwpodiatry.com.au Station Street
          Clinic - 03 5941 1611 Cardinia Medical Centre - 03 5941 6013 Koo Wee
          Rup Medical Centre - 03 5997 1222 East Bentleigh Health Group - 03
          9579 3999 Home About Services Contact Contact Us — PW Podiatry Home
          About Services Children's Feet Diabetes Foot Care Foot Mobilisation
          Fungal Toenails General Foot Care Ingrown Toenails Orthotics
          Prolotherapy Injections Sports Injuries Blog Contact Us BOOK ONLINE
          NOW Home About Services Children's Feet Diabetes Foot Care Foot
          Mobilisation Fungal Toenails General Foot Care Ingrown Toenails
          Orthotics Prolotherapy Injections Sports Injuries Blog Contact Us BOOK
          ONLINE NOW Contact Us! BOOK ONLINE NOW Station Street Clinic 03 5941
          1611 34 Station Street Pakenham VIC 3810 Cardinia Medical Centre 03
          5941 6013 180 Princes Hwy Pakenham VIC 3810 Koo Wee Rup Medical Centre
          03 5997 1222 303 Rossiter Road Koo Wee Rup VIC 3981 East Bentleigh
          Health Group 03 9579 3999 884 Centre Rd Bentleigh East VIC 3165 Email:
          hello@pwpodiatry.com.au Back to Top hello@pwpodiatry.com.au Station
          Street Clinic - 03 5941 1611 Cardinia Medical Centre - 03 5941 6013
          Koo Wee Rup Medical Centre - 03 5997 1222 East Bentleigh Health Group
          - 03 9579 3999 Home About Services Contact Children's Feet — PW
          Podiatry Home About Services Children's Feet Diabetes Foot Care Foot
          Mobilisation Fungal Toenails General Foot Care Ingrown Toenails
          Orthotics Prolotherapy Injections Sports Injuries Blog Contact Us BOOK
          ONLINE NOW Home About Services Children's Feet Diabetes Foot Care Foot
          Mobilisation Fungal Toenails General Foot Care Ingrown Toenails
          Orthotics Prolotherapy Injections Sports Injuries Blog Contact Us BOOK
          ONLINE NOW Children's Feet Services Children's Feet Diabetes Foot Care
          Foot Mobilisation Fungal Toenails General Foot Care Ingrown Toenails
          Orthotics Prolotherapy Injections Sports Injuries Children’s feet are
          not just small adult feet, the bones in the feet are still very soft
          as they have not fully developed and hardened. This means unwanted
          forces on children’s feet have the capacity to alter development,
          which can cause issues later in life. Regular assessments of
          children's footwear is important as the child grows. The walking
          pattern of children also typically differs to that of an adult.
          Children's lower limb and walking assessments is something we conduct
          at PW Podiatry and things that may come up include instability,
          intoeing, heel pain, knee pain, knock knees, bow legs, juvenile
          bunions and more. For some conditions in children's lower limbs the
          recommended pathway is to simply allow further development to occur
          and monitor progress. In other cases we may intervene with certain
          treatments including footwear changes, foot orthotics and exercises to
          strengthen muscle/tendon units. We also treat children with general
          treatments such as ingrown toe nails, callus and warts. Back to Top
          hello@pwpodiatry.com.au Station Street Clinic - 03 5941 1611 Cardinia
          Medical Centre - 03 5941 6013 Koo Wee Rup Medical Centre - 03 5997
          1222 East Bentleigh Health Group - 03 9579 3999 Home About Services
          Contact
        CONTENT
      end

      it "returns a collection of matches" do
        expected = [
          "online now station street clinic 34 station street pakenham vic 3810 cardinia medical centre",
          "vic 3810 cardinia medical centre 180 princes hwy pakenham vic 3810 koo wee rup",
          "rup medical centre 303 rossiter road koo wee rup vic 3981 east bentleigh health",
          "east bentleigh health group 884 centre rd bentleigh east vic 3165 email: back",
        ]

        expect(subject).to match_array(expected)
      end
    end
  end
end
