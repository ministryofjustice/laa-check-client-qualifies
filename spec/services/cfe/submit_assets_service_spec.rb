require "rails_helper"

RSpec.describe Cfe::SubmitAssetsService do
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
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

      it "calls CFE appropriately" do
        expect(mock_connection).to receive(:create_capitals).with(
          cfe_assessment_id,
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
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          { additional_properties: [{ outstanding_mortgage: 1313,
                                      percentage_owned: 44,
                                      shared_with_housing_assoc: false,
                                      value: 123 }],
            main_home: { outstanding_mortgage: 123_123,
                         percentage_owned: 91,
                         shared_with_housing_assoc: false,
                         value: 234_234 } },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the client is asylum supported" do
      let(:session_data) do
        {
          "proceeding_type" => "IM030",
          "asylum_support" => true,
        }
      end

      it "does not call CFE" do
        expect(mock_connection).not_to receive(:create_capitals)
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there are no homes" do
      let(:session_data) do
        {
          "property_owned" => "none",
          "partner_property_owned" => "none",
          "property_value" => 0,
          "partner_property_value" => 0,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
        }
      end

      it "does not call CFE" do
        expect(mock_connection).not_to receive(:create_capitals)
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there is a second property but no main home" do
      let(:session_data) do
        {
          "property_value" => 100_000,
          "property_mortgage" => 0,
          "property_percentage_owned" => 100,
          "in_dispute" => %w[],
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
        }
      end

      it "calls CFE with a fake main home" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            additional_properties: [
              {
                outstanding_mortgage: 0.0,
                percentage_owned: 100,
                shared_with_housing_assoc: false,
                value: 100_000,
              },
            ],
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 0,
              shared_with_housing_assoc: false,
              value: 0,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there is a SMOD second property" do
      let(:session_data) do
        {
          "property_value" => 100_000,
          "property_mortgage" => 0,
          "property_percentage_owned" => 100,
          "in_dispute" => %w[property],
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
        }
      end

      it "calls CFE with the right SMOD value" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
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
              value: 0,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when main property is owned outright" do
      let(:session_data) do
        {
          "property_owned" => "outright",
          "house_value" => 100_000,
          "percentage_owned" => 100,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
        }
      end

      it "calls CFE with appropriate details including zero mortgage" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              value: 100_000,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when main property is owned outright and disputed" do
      let(:session_data) do
        {
          "property_owned" => "outright",
          "house_value" => 100_000,
          "percentage_owned" => 100,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
          "house_in_dispute" => true,
        }
      end

      it "calls CFE with appropriate flag" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
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
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when main property is owned outright by partner" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_property_owned" => "outright",
          "partner_house_value" => 100_000,
          "partner_percentage_owned" => 100,
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_valuables" => 0,
          "partner_property_value" => 0,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
        }
      end

      it "calls CFE with appropriate details based on partner ownership" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              value: 100_000,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when main property is owned with mortgage by partner" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_property_owned" => "with_mortgage",
          "partner_house_value" => 100_000,
          "partner_mortgage" => 50_000,
          "partner_percentage_owned" => 100,
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_valuables" => 0,
          "partner_property_value" => 0,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
        }
      end

      it "calls CFE with appropriate details based on partner ownership" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            main_home: {
              outstanding_mortgage: 50_000,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              value: 100_000,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when main property is owned outright between client and partner" do
      let(:session_data) do
        {
          "property_owned" => "outright",
          "joint_ownership" => true,
          "joint_percentage_owned" => 30,
          "house_value" => 100_000,
          "percentage_owned" => 40,
          "savings" => 0,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
        }
      end

      it "sums the ownership percentages when talking to CFE" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 70,
              shared_with_housing_assoc: false,
              value: 100_000,
            },
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when assets marked as SMOD, but SMOD does not apply" do
      let(:session_data) do
        {
          "property_owned" => "outright",
          "joint_ownership" => false,
          "house_value" => 100_000,
          "percentage_owned" => 100,
          "house_in_dispute" => true,
          "savings" => 100,
          "investments" => 0,
          "valuables" => 0,
          "property_value" => 0,
          "in_dispute" => %w[savings],
          "proceeding_type" => "IM030",
        }
      end

      it "does not tell CFE about SMOD" do
        expect(mock_connection).to receive(:create_properties).with(
          cfe_assessment_id,
          {
            main_home: {
              outstanding_mortgage: 0,
              percentage_owned: 100,
              shared_with_housing_assoc: false,
              value: 100_000,
            },
          },
        )
        expect(mock_connection).to receive(:create_capitals).with(
          cfe_assessment_id,
          {
            bank_accounts: [
              { value: 100,
                description: "Liquid Asset",
                subject_matter_of_dispute: false },
            ],
            non_liquid_capital: [],
          },
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
