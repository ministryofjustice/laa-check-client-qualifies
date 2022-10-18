require "rails_helper"

RSpec.describe SubmitEmploymentIncomeService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "employed" => true,
      "gross_income" => "2345.0",
      "income_tax" => "234.0",
      "national_insurance" => "123.0",
      "frequency" => "monthly",
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "with an employed applicant" do
        let(:employment_data) do
          [
            {
              name: "Job",
              client_id: "ID",
              payments: [
                {
                  gross: 2345.to_d,
                  tax: -234.to_d,
                  national_insurance: -123.to_d,
                  client_id: "id-0",
                  date: Date.current - 0.months,
                  benefits_in_kind: 0,
                  net_employment_income: 1988.to_d,
                },
                {
                  gross: 2345.to_d,
                  tax: -234.to_d,
                  national_insurance: -123.to_d,
                  client_id: "id-1",
                  date: Date.current - 1.month,
                  benefits_in_kind: 0,
                  net_employment_income: 1988.to_d,
                },
                {
                  gross: 2345.to_d,
                  tax: -234.to_d,
                  national_insurance: -123.to_d,
                  client_id: "id-2",
                  date: Date.current - 2.months,
                  benefits_in_kind: 0,
                  net_employment_income: 1988.to_d,
                },
              ],
            },
          ]
        end

        it "makes a successful call" do
          expect(mock_connection).to receive(:create_employment).with(cfe_estimate_id,
                                                                      employment_data)

          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
