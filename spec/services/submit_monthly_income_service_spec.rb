require "rails_helper"

RSpec.describe SubmitMonthlyIncomeService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "monthly_incomes" => ["", "maintenance", "student_finance"],
      "friends_or_family" => nil,
      "maintenance" => "234.0",
      "property_or_lodger" => nil,
      "pension" => nil,
      "student_finance" => "345.0",
      "other" => nil,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data with monthly income" do
      it "is successful" do
        form = Flow::MonthlyIncomeHandler.model(session_data)
        pp form
        expect(mock_connection).to receive(:create_student_loan).with(cfe_estimate_id, 345)
        expect(mock_connection).to receive(:create_regular_payments).with(cfe_estimate_id, form, nil)
        service.call(cfe_estimate_id, session_data)
      end
    end
  end
end
