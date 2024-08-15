require "rails_helper"

RSpec.describe CfeService do
  describe ".call" do
    context "when there is a full set of data" do
      let(:session_data) { FactoryBot.build(:full_session) }
      let(:api_response) { { foo: :bar } }
      let(:mock_connection) { instance_double(CfeConnection) }
      let(:arbitrary_fixed_time) { Date.new(2023, 3, 8) }
      let(:assessment_id) { "assessment-id" }
      let(:completed_steps) { [] }

      before do
        travel_to arbitrary_fixed_time
      end

      it "sends all required information to CFE endpoints and returns the result" do
        expect(Cfe::ApplicantPayloadService).to receive(:call)
        expect(Cfe::AssessmentPayloadService).to receive(:call)
        expect(Cfe::AssetsPayloadService).to receive(:call)
        expect(Cfe::DependantsPayloadService).to receive(:call)
        expect(Cfe::EmploymentIncomePayloadService).to receive(:call)
        expect(Cfe::IrregularIncomePayloadService).to receive(:call)
        expect(Cfe::PartnerPayloadService).to receive(:call)
        expect(Cfe::ProceedingsPayloadService).to receive(:call)
        expect(Cfe::RegularTransactionsPayloadService).to receive(:call)
        expect(Cfe::VehiclePayloadService).to receive(:call)

        allow(CfeConnection).to receive(:assess).and_return api_response

        result = described_class.call(session_data, completed_steps)
        expect(result).to eq api_response
      end
    end
  end
end
