require "rails_helper"

RSpec.describe Cfe::AssetsPayloadService do
  describe ".call" do
    let(:payload) { {} }

    before do
      described_class.call(session_data, payload, relevant_steps)
    end

    context "when there is a full set of data" do
      let(:session_data) do
        {
          "property_owned" => "with_mortgage",
          "house_value" => 234_234,
          "mortgage" => 123_123,
          "percentage_owned" => 80,
          "house_in_dispute" => false,
          "additional_property_owned" => "with_mortgage",
          "additional_properties" => [{
            "house_value" => 123,
            "mortgage" => 1313,
            "percentage_owned" => 44,
            "house_in_dispute" => false,
          }],
          "bank_accounts" => [{ "amount" => 553, "account_in_dispute" => true }],
          "investments" => 345,
          "valuables" => 665,
          "investments_in_dispute" => true,
          "valuables_in_dispute" => true,
        }
      end
      let(:relevant_steps) { %i[assets property_entry additional_property_details] }

      it "populates the payload appropriately" do
        expect(payload[:capitals]).to eq(
          { bank_accounts: [{ description: "Liquid Asset",
                              subject_matter_of_dispute: true,
                              value: 553 }],
            non_liquid_capital: [{ description: "Non Liquid Asset",
                                   subject_matter_of_dispute: true,
                                   value: 345 },
                                 { description: "Non Liquid Asset",
                                   subject_matter_of_dispute: true,
                                   value: 665 }] },
        )
        expect(payload[:properties]).to eq(
          { additional_properties: [{ outstanding_mortgage: 1313,
                                      percentage_owned: 44,
                                      shared_with_housing_assoc: false,
                                      subject_matter_of_dispute: false,
                                      value: 123 }],
            main_home: { outstanding_mortgage: 123_123,
                         percentage_owned: 80,
                         shared_with_housing_assoc: false,
                         subject_matter_of_dispute: false,
                         value: 234_234 } },
        )
      end
    end

    context "when an additional property is owned with a mortgage" do
      let(:session_data) do
        {
          "additional_property_owned" => "with_mortgage",
          "additional_properties" => [{
            "house_value" => 123,
            "mortgage" => 1313,
            "percentage_owned" => 44,
            "house_in_dispute" => true,
          }],
          "bank_accounts" => [{ "amount" => 0, "account_in_dispute" => false }],
          "investments" => 0,
          "valuables" => 0,
          "investments_in_dispute" => false,
          "valuables_in_dispute" => false,
        }
      end
      let(:relevant_steps) { [:additional_property_details] }

      it "populates the payload with content from the standalone additional property screens" do
        expect(payload[:properties][:additional_properties]).to eq(
          [{ outstanding_mortgage: 1313,
             percentage_owned: 44,
             shared_with_housing_assoc: false,
             subject_matter_of_dispute: true,
             value: 123 }],
        )
      end
    end

    context "when an additional property is owned outright" do
      let(:session_data) do
        {
          "additional_property_owned" => "outright",
          "additional_properties" => [{
            "house_value" => 123,
            "percentage_owned" => 44,
            "house_in_dispute" => false,
          }],
          "bank_accounts" => [{ "amount" => 0, "account_in_dispute" => false }],
          "investments" => 0,
          "valuables" => 0,
          "investments_in_dispute" => false,
          "valuables_in_dispute" => false,
        }
      end
      let(:relevant_steps) { [:additional_property_details] }

      it "populates the payload with content from the standalone additional property screens" do
        expect(payload[:properties][:additional_properties]).to eq(
          [{ outstanding_mortgage: 0,
             percentage_owned: 44,
             shared_with_housing_assoc: false,
             subject_matter_of_dispute: false,
             value: 123 }],
        )
      end
    end

    context "when the client is asylum supported" do
      let(:session_data) do
        {
          "immigration_or_asylum_type_upper_tribunal" => "immigration_upper",
          "asylum_support" => true,
        }
      end
      let(:relevant_steps) { [:asylum_support] }

      it "does not populate the payload" do
        expect(payload[:capitals]).to eq nil
      end
    end

    context "when there are no homes" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_no_main_home,
                         :with_zero_capital_assets)
      end
      let(:relevant_steps) { [] }

      it "does not populate the payload" do
        expect(payload[:properties]).to eq nil
      end
    end

    context "when there is a second property but no main home" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_no_main_home,
                         :with_zero_capital_assets,
                         additional_property_owned: "with_mortgage",
                         additional_properties: [{
                           "house_value" => 100_000,
                           "mortgage" => 1,
                           "percentage_owned" => 100,
                           "house_in_dispute" => false,
                         }])
      end
      let(:relevant_steps) { [:additional_property_details] }

      it "adds a fake main home to the payload" do
        expect(payload[:properties]).to eq(
          {
            additional_properties: [
              {
                outstanding_mortgage: 1.0,
                percentage_owned: 100,
                shared_with_housing_assoc: false,
                subject_matter_of_dispute: false,
                value: 100_000,
              },
            ],
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 0,
              shared_with_housing_assoc: false,
              subject_matter_of_dispute: false,
              value: 0,
            },
          },
        )
      end
    end

    context "when there is a SMOD second property" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_no_main_home,
                         :with_zero_capital_assets,
                         additional_property_owned: "outright",
                         additional_properties: [{
                           "house_value" => 100_000,
                           "percentage_owned" => 100,
                           "house_in_dispute" => true,
                         }])
      end
      let(:relevant_steps) { %i[additional_property_details] }

      it "populates the payload with the right SMOD value" do
        expect(payload[:properties]).to eq(
          {
            additional_properties: [
              {
                outstanding_mortgage: 0.0,
                percentage_owned: 100,
                shared_with_housing_assoc: false,
                subject_matter_of_dispute: true,
                value: 100_000,
              },
            ],
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 0,
              shared_with_housing_assoc: false,
              subject_matter_of_dispute: false,
              value: 0,
            },
          },
        )
      end
    end

    context "when main property is owned outright" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_main_home,
                         :with_zero_capital_assets,
                         property_owned: "outright",
                         house_value: 100_000)
      end
      let(:relevant_steps) { %i[property_entry] }

      it "populates the payload with appropriate details including zero mortgage" do
        expect(payload[:properties]).to eq(
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              subject_matter_of_dispute: false,
              value: 100_000,
            },
          },
        )
      end
    end

    context "when main property is owned outright and disputed" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_main_home,
                         :with_zero_capital_assets,
                         property_owned: "outright",
                         house_in_dispute: true,
                         house_value: 100_000)
      end
      let(:relevant_steps) { %i[property_entry] }

      it "populates the payload with appropriate flag" do
        expect(payload[:properties]).to eq(
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              value: 100_000,
              subject_matter_of_dispute: true,
            },
          },
        )
      end
    end

    context "when assets marked as SMOD, but SMOD does not apply" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_main_home,
                         :with_zero_capital_assets,
                         bank_accounts: [{ "amount" => 123, "account_in_dispute" => true }],
                         house_in_dispute: true,
                         immigration_or_asylum_type_upper_tribunal: "immigration_upper")
      end
      let(:relevant_steps) { %i[assets property_entry] }

      it "does not include SMOD in the payload" do
        expect(payload.dig(:properties, :main_home, :subject_matter_of_dispute)).to eq false
        expect(payload.dig(:capitals, :bank_accounts, 0, :subject_matter_of_dispute)).to eq false
      end
    end

    context "when there is no additional property data" do
      let(:session_data) do
        {
          "bank_accounts" => [{ "amount" => 553, "account_in_dispute" => false }],
          "investments" => 345,
          "valuables" => 665,
          "investments_in_dispute" => false,
          "valuables_in_dispute" => false,
        }
      end
      let(:relevant_steps) { [] }

      it "does not additional property data" do
        expect(payload[:properties]).to eq(nil)
      end
    end

    context "when the data is incohesive" do
      let(:session_data) do
        {
          "immigration_or_asylum_type_upper_tribunal" => "immigration_upper",
          "asylum_support" => true,
          "bank_accounts" => [{ "amount" => 553, "account_in_dispute" => false }],
          "investments" => 345,
          "valuables" => 665,
          "investments_in_dispute" => false,
          "valuables_in_dispute" => false,
        }
      end
      let(:relevant_steps) { %i[asylum_support assets] }

      it "returns correct result" do
        # this one is a new test which fails currently - this is the kind of thing
        # I am concerned about when we deduce what is valid to send to CFE.
        # if a user has changed some answers then I think we might get into this state.
        # Where we have been using def valid_step? previously, the assets would appear
        # as not a valid step (i.e. not in the navigation) and therefore would not have been sent to CFE - we are changing this.
        expect(payload[:capitals]).to eq nil
      end
    end
  end
end
