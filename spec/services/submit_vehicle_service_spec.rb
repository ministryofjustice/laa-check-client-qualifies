require "rails_helper"

RSpec.describe SubmitVehicleService do
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is an additional vehicle" do
      let(:session_data) do
        {
          "vehicle_owned" => "foo",
          "vehicle_finance" => 0,
          "vehicle_pcp" => false,
          "vehicle_over_3_years_ago" => false,
          "vehicle_value" => 15_000,
          "vehicle_in_regular_use" => false,
          "vehicle_in_dispute" => false,
          "additional_vehicle_owned" => true,
          "additional_vehicle_finance" => 15,
          "additional_vehicle_pcp" => true,
          "additional_vehicle_over_3_years_ago" => true,
          "additional_vehicle_value" => 7_000,
          "additional_vehicle_in_regular_use" => true,
          "additional_vehicle_in_dispute" => true,
        }
      end

      it "uses the specified proceeding type" do
        vehicles = [{ date_of_purchase: 2.years.ago.to_date,
                      in_regular_use: false,
                      loan_amount_outstanding: 0,
                      subject_matter_of_dispute: false,
                      value: 15_000 },
                    { date_of_purchase: 4.years.ago.to_date,
                      in_regular_use: true,
                      loan_amount_outstanding: 15,
                      subject_matter_of_dispute: true,
                      value: 7_000 }]
        expect(mock_connection).to receive(:create_vehicles).with(cfe_estimate_id, vehicles:)
        described_class.call(mock_connection, cfe_estimate_id, session_data)
      end
    end

    context "when alternate flags used" do
      let(:session_data) do
        {
          "vehicle_owned" => "foo",
          "vehicle_finance" => 0,
          "vehicle_pcp" => false,
          "vehicle_over_3_years_ago" => false,
          "vehicle_value" => 15_000,
          "vehicle_in_regular_use" => false,
          "vehicle_in_dispute" => false,
          "additional_vehicle_owned" => true,
          "additional_vehicle_finance" => nil,
          "additional_vehicle_pcp" => false,
          "additional_vehicle_over_3_years_ago" => false,
          "additional_vehicle_value" => 7_000,
          "additional_vehicle_in_regular_use" => true,
          "additional_vehicle_in_dispute" => true,
        }
      end

      it "uses the specified proceeding type" do
        vehicles = [{ date_of_purchase: 2.years.ago.to_date,
                      in_regular_use: false,
                      loan_amount_outstanding: 0,
                      subject_matter_of_dispute: false,
                      value: 15_000 },
                    { date_of_purchase: 2.years.ago.to_date,
                      in_regular_use: true,
                      loan_amount_outstanding: 0,
                      subject_matter_of_dispute: true,
                      value: 7_000 }]
        expect(mock_connection).to receive(:create_vehicles).with(cfe_estimate_id, vehicles:)
        described_class.call(mock_connection, cfe_estimate_id, session_data)
      end
    end
  end
end
