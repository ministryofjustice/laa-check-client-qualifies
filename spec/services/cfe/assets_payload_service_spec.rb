require "rails_helper"

RSpec.describe Cfe::AssetsPayloadService do
  describe ".call" do
    let(:payload) { {} }

    before do
      described_class.call(session_data, payload)
    end

    context "when there is a full set of data" do
      let(:session_data) do
        {
          "property_owned" => "with_mortgage",
          "house_value" => 234_234,
          "mortgage" => 123_123,
          "percentage_owned" => 80,
          "house_in_dispute" => false,
          "joint_ownership" => true,
          "joint_percentage_owned" => 11,
          "property_value" => 123,
          "property_mortgage" => 1313,
          "property_percentage_owned" => 44,
          "savings" => 553,
          "investments" => 345,
          "valuables" => 665,
          "in_dispute" => %w[savings investments valuables],
        }
      end

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
                         percentage_owned: 91,
                         shared_with_housing_assoc: false,
                         subject_matter_of_dispute: false,
                         value: 234_234 } },
        )
      end
    end

    context "when the client is asylum supported" do
      let(:session_data) do
        {
          "proceeding_type" => "IM030",
          "asylum_support" => true,
        }
      end

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

      it "does not populate the payload" do
        expect(payload[:properties]).to eq nil
      end
    end

    context "when there is a second property but no main home" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_no_main_home,
                         :with_zero_capital_assets,
                         property_value: 100_000,
                         property_mortgage: 0,
                         property_percentage_owned: 100)
      end

      it "adds a fake main home to the payload" do
        expect(payload[:properties]).to eq(
          {
            additional_properties: [
              {
                outstanding_mortgage: 0.0,
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
                         property_value: 100_000,
                         property_mortgage: 0,
                         property_percentage_owned: 100,
                         in_dispute: %w[property])
      end

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

    context "when main property is owned outright by partner" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_partner_owned_main_home,
                         :with_zero_capital_assets,
                         partner_house_value: 100_000,
                         partner_property_owned: "outright",
                         partner_percentage_owned: 100)
      end

      it "populates the payload with appropriate details based on partner ownership" do
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

    context "when main property is owned with mortgage by partner" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_partner_owned_main_home,
                         :with_zero_capital_assets,
                         partner_house_value: 100_000,
                         partner_property_owned: "with_mortgage",
                         partner_mortgage: 50_000,
                         partner_percentage_owned: 100)
      end

      it "populates the payload with appropriate details based on partner ownership" do
        expect(payload[:properties]).to eq(
          {
            main_home: {
              outstanding_mortgage: 50_000,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              subject_matter_of_dispute: false,
              value: 100_000,
            },
          },
        )
      end
    end

    context "when main property is owned outright between client and partner" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         :with_main_home,
                         :with_zero_capital_assets,
                         property_owned: "outright",
                         joint_ownership: true,
                         joint_percentage_owned: 30,
                         percentage_owned: 40,
                         house_value: 100_000)
      end

      it "sums the ownership percentages" do
        expect(payload[:properties]).to eq(
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 70,
              shared_with_housing_assoc: false,
              subject_matter_of_dispute: false,
              value: 100_000,
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
                         savings: 100,
                         house_in_dispute: true,
                         in_dispute: %w[savings],
                         proceeding_type: "IM030")
      end

      it "does not include SMOD in the payload" do
        expect(payload.dig(:properties, :main_home, :subject_matter_of_dispute)).to eq false
        expect(payload.dig(:capitals, :bank_accounts, 0, :subject_matter_of_dispute)).to eq false
      end
    end
  end
end
