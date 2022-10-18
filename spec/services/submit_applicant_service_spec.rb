require "rails_helper"

RSpec.describe SubmitApplicantService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "over_60" => over_60,
      "passporting" => passporting,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "with an applicant under 50 not passported" do
        let(:date_of_birth) { 50.years.ago.to_date }
        let(:receives_qualifying_benefit) { false }
        let(:over_60) { false }
        let(:passporting) { false }

        it "makes a successful call" do
          expect(mock_connection).to receive(:create_applicant).with(cfe_estimate_id,
                                                                     date_of_birth:,
                                                                     receives_qualifying_benefit:)
          service.call(cfe_estimate_id, session_data)
        end
      end

      describe "with an applicant over 60 and passported" do
        let(:date_of_birth) { 70.years.ago.to_date }
        let(:receives_qualifying_benefit) { true }
        let(:over_60) { true }
        let(:passporting) { true }

        it "makes a successful call" do
          expect(mock_connection).to receive(:create_applicant).with(cfe_estimate_id,
                                                                     date_of_birth:,
                                                                     receives_qualifying_benefit:)
          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
