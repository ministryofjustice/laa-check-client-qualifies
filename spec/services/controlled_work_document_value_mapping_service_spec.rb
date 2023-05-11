require "rails_helper"

RSpec.describe ControlledWorkDocumentValueMappingService do
  it "raises an error if it encounters an unknown mapping type" do
    mappings = [{ name: "foo", type: "typo", source: "some_string" }]
    session_data = {}
    expect { described_class.call(session_data, mappings) }.to raise_error "Unknown mapping type typo for mapping foo"
  end

  it "retrieves values from the session based on mappings" do
    mappings = [{ name: "foo", type: "text", source: "aggregate_partner?" }]
    session_data = { "partner" => "true" }
    expect(described_class.call(session_data, mappings)["foo"]).to eq true
  end

  it "zeroes out negative values" do
    mappings = [{ name: "foo", type: "text", source: "main_home_value" }]
    session_data = {
      "property_owned" => "outright",
      "api_response" => {
        "assessment" => {
          "capital" => {
            "capital_items" => {
              "properties" => {
                "main_home" => {
                  "value" => -33.1,
                },
              },
            },
          },
        },
      },
    }
    expect(described_class.call(session_data, mappings)["foo"]).to eq "0"
  end

  context "with a comprehensive session with no disputed assets" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_main_home,
        :with_partner,
        savings: 111,
        investments: 222,
        valuables: 555,
        joint_ownership: true,
        percentage_owned: 25,
        joint_percentage_owned: 25,
        api_response: FactoryBot.build(:api_result, main_home: FactoryBot.build(:property_api_result, value: 250_000)).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => "Yes", # Not passporting
        "Go to question 2" => "No", # Asylum supported not given
        "Please complete Part A Capital Subject matter of dispute" => "No_4", # No SMOD
        "Please provide details of both clients and partners means" => "Yes_3", # Has a partner
        "undefined_26" => "250,000", # Property worth £250,000
        "undefined_42" => "555", # Valuables
        "undefined_40" => "222", # Investments
        "undefined_38" => "111", # Savings
        "undefined_30" => "50", # joint percentage owned
      }
      expect(result).to include(representative_sample)
    end

    it "can successfully populate a CW2 IMM form" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw2.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "CheckBox13" => 1, # Has a partner
        "CheckBox69" => 1, # Not passporting
        "CheckBox64" => 1, # Asylum support not given and defaults to 'no' option
        "FillText44" => "250,000", # Property worth £250,000
        "FillText2" => "111", # Savings
        "FillText6" => "222", # Investments
        "FillText11" => "555", # Valuables
        "FillText66" => "50", # joint percentage owned
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
        "FillText24" => "100,000", # client final assessed amount of equity for main home non-SMOD
      }
      expect(result).to include(representative_sample)
    end
  end

  context "with disputed main home and additional property" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_main_home,
        house_in_dispute: true,
        in_dispute: %w[property],
        api_response: FactoryBot.build(:api_result,
                                       main_home: FactoryBot.build(:property_api_result, value: 250_000.11),
                                       additional_property: FactoryBot.build(:property_api_result, value: 100_000.22)).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => "Yes", # Not passporting
        "Go to question 2" => "No", # Asylum supported not given
        "Please complete Part A Capital Subject matter of dispute" => "Yes_5", # SMOD
        "Please provide details of both clients and partners means" => "No_2", # No partner
        "undefined_26" => nil, # Non smod value is nil
        "undefined_10" => "250,000.11", # SMOD home worth £250,000
        "Other property 1" => "100,000.22", # SMOD other property worth £100,000
      }
      expect(result).to include(representative_sample)
    end

    it "can successfully populate CW5 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw5.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "CheckBox46" => "1", # Not passporting
        "CheckBox2" => "1", # SMOD
        "CheckBox1" => "1", # No partner
        "FillText11" => nil, # Non smod value is nil
        "FillText27" => "250,000.11", # SMOD home worth £250,000
        "FillText29" => "100,000.22", # SMOD other property worth £100,000
      }
      expect(result).to include(representative_sample)
    end
  end

  context "with asylum_support" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_asylum_support,
        valuables: 555,
        savings: 111,
        investments: 222,
        in_dispute: %w[valuables savings investments],
        api_response: FactoryBot.build(:api_result).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => nil, # Not passporting
        "Go to question 2" => "Yes_2", # Asylum supported
        "Please complete Part A Capital Subject matter of dispute" => nil, # SMOD not relevant
        "undefined_42" => nil, # Valuables not relevant
        "undefined_40" => nil, # Investments not relevant
        "undefined_38" => nil, # Savings not relevant
      }
      expect(result).to include(representative_sample)
    end

    it "can successfully populate a CW2 IMM form" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw2.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "CheckBox69" => nil, # Not passporting
        "CheckBox64" => nil, # asylum supported No field
        "CheckBox63" => 1, # asylum supported Yes field
        "FillText44" => nil, # Property worth £250,000
        "FillText11" => nil, # SMOD valuables are not relevant so are not displayed
      }
      expect(result).to include(representative_sample)
    end
  end

  context "with property/capital in dispute" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_main_home_in_dispute,
        :with_partner,
        savings: 111,
        investments: 222,
        valuables: 555,
        in_dispute: %w[savings investments valuables property],
        api_response: FactoryBot.build(:api_result,
                                       main_home: FactoryBot.build(:property_api_result, value: 250_000),
                                       additional_property: FactoryBot.build(:property_api_result,
                                                                             outstanding_mortgage: 120_000,
                                                                             percentage_owned: 75)).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => "Yes", # Not passporting
        "Go to question 2" => "No", # Asylum supported not given
        "Please complete Part A Capital Subject matter of dispute" => "Yes_5", # SMOD
        "Please provide details of both clients and partners means" => "Yes_3", # Has a partner
        "undefined_26" => nil, # Non SMOD Property value
        "undefined_10" => "250,000", # SMOD Property worth £250,000
        "undefined_21" => "111", # SMOD savings
        "undefined_23" => "555", # SMOD valuables
        "undefined_22" => "222", # SMOD investments
        "Other property 1" => "200,000", # SMOD investments
        "undefined_15" => "75", # SMOD investments
        "Other property 2" => "120,000", # SMOD investments
      }
      expect(result).to include(representative_sample)
    end
  end

  context "with joint owned property in dispute" do
    let(:session_data) do
      FactoryBot.build(
        :minimal_complete_session,
        :with_joint_owned_main_home_in_dispute,
        :with_partner,
        in_dispute: %w[property],
        percentage_owned: 25,
        joint_percentage_owned: 25,
        api_response: FactoryBot.build(:api_result,
                                       main_home: FactoryBot.build(:property_api_result, value: 250_000),
                                       additional_property: FactoryBot.build(:property_api_result,
                                                                             outstanding_mortgage: 120_000,
                                                                             percentage_owned: 75)).with_indifferent_access,
      )
    end

    it "can successfully populate CW1 form fields" do
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/cw1.yml")).map(&:with_indifferent_access)
      result = described_class.call(session_data, mappings)
      representative_sample = {
        "Check Box21" => "Yes", # Not passporting
        "Go to question 2" => "No", # Asylum supported not given
        "Please complete Part A Capital Subject matter of dispute" => "Yes_5", # SMOD
        "Please provide details of both clients and partners means" => "Yes_3", # Has a partner
        "undefined_26" => nil, # Non SMOD Property value
        "undefined_10" => "250,000", # SMOD Property worth £250,000
        "Other property 1" => "200,000", # additional property value
        "undefined_15" => "75", # additional property percentage
        "Other property 2" => "120,000", # additional property mortgage
        "undefined_14" => "50", # joint perecentage owned (main home)
      }
      expect(result).to include(representative_sample)
    end
  end
end
