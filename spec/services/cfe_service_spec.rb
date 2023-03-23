require "rails_helper"

RSpec.describe CfeService do
  describe ".call", :controlled_flag do
    context "when there is a full set of data" do
      let(:session_data) { FactoryBot.build(:full_session) }
      let(:api_response) { { foo: :bar } }
      let(:mock_connection) { instance_double(CfeConnection) }
      let(:arbitrary_fixed_time) { Date.new(2023, 3, 8) }
      let(:assessment_id) { "assessment-id" }

      before do
        travel_to arbitrary_fixed_time
        allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      end

      it "sends all required information to CFE endpoints and returns the result" do
        allow(mock_connection).to receive(:create_assessment_id).and_return(assessment_id)

        expect(mock_connection).to receive(:create_dependants)
        expect(mock_connection).to receive(:create_proceeding_types)
        expect(mock_connection).to receive(:create_employments)
        expect(mock_connection).to receive(:create_state_benefits)
        expect(mock_connection).to receive(:create_irregular_incomes)
        expect(mock_connection).to receive(:create_vehicles)
        expect(mock_connection).to receive(:create_capitals)
        expect(mock_connection).to receive(:create_properties)
        expect(mock_connection).to receive(:create_regular_transactions)
        expect(mock_connection).to receive(:create_applicant)
        expect(mock_connection).to receive(:create_partner_financials)

        allow(mock_connection).to receive(:api_result).with(assessment_id).and_return(api_response)

        result = described_class.call(session_data)
        expect(result).to eq api_response
      end
    end
  end

  describe ".create_assessment_id" do
    let(:mock_connection) { instance_double(CfeConnection) }
    let(:session_data) { {} }

    it "does not include level of help in payload if none is specified" do
      expect(mock_connection).to receive(:create_assessment_id).with({ submission_date: Date.current })
      described_class.create_assessment_id(mock_connection, session_data)
    end
  end
end
