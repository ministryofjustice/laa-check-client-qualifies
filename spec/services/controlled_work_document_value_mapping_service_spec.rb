require "rails_helper"

RSpec.describe ControlledWorkDocumentValueMappingService do
  it "raises an error if it encounters an unknown mapping type" do
    mappings = [{ name: "foo", type: "typo", source: "from_attribute", attribute: "bar" }]
    session_data = {}
    expect { described_class.call(session_data, mappings) }.to raise_error "Unknown mapping type typo for mapping foo"
  end

  it "raises an error if it encounters an unknown mapping value type" do
    mappings = [{ name: "foo", type: "text", source: "typo", attribute: "bar" }]
    session_data = {}
    expect { described_class.call(session_data, mappings) }.to raise_error "Unknown mapping value type typo for mapping foo"
  end

  it "retrieves values from the session based on mappings" do
    mappings = [{ name: "foo", type: "text", source: "from_attribute", attribute: "level_of_help" }]
    session_data = { "level_of_help" => "controlled" }
    expect(described_class.call(session_data, mappings)["foo"]).to eq "controlled"
  end

  it "respects 'skip_if'" do
    mappings = [{ name: "foo", type: "text", source: "from_attribute", attribute: "level_of_help", skip_if: "partner" }]
    session_data = { "level_of_help" => "controlled", "partner" => true }
    expect(described_class.call(session_data, mappings)["foo"]).to eq nil
  end

  it "respects 'skip_unless'" do
    mappings = [{ name: "foo", type: "text", source: "from_attribute", attribute: "level_of_help", skip_unless: "partner" }]
    session_data = { "level_of_help" => "controlled", "partner" => false }
    expect(described_class.call(session_data, mappings)["foo"]).to eq nil
  end

  context "with a comprehensive session" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_partner,
        api_response: FactoryBot.build(:api_result, main_home: FactoryBot.build(:property_api_result, value: 250_000)).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => "Yes", # Not passporting
        "Go to question 2" => "No", # Not asylum supported
        "Please complete Part A Capital Subject matter of dispute" => "No_4", # No SMOD
        "Please provide details of both clients and partners means" => "Yes_3", # Has a partner
        "undefined_26" => "250,000", # Property worth £250,000
      }
      expect(result).to include(representative_sample)
    end

    it "can successfully populate CW5 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw5.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "CheckBox4" => "1", # client has partner
        "CheckBox1" => nil, # client does not have partner
        "FillText11" => "250,000", # client main home value non-SMOD
        "FillText14" => "90,000", # client main home mortgage non-SMOD
        "FillText20" => "110,000", # client main home net equity non-SMOD
      }
      expect(result).to include(representative_sample)
    end
  end
end
