require "rails_helper"

RSpec.describe SubmitApplicantService do
  let(:service) { described_class }
  let(:session_data) do
    {
      date_of_birth: 30.years.ago.to_date,
      has_partner_opponent: false,
      receives_qualifying_benefit: true,
      employed: false,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "makes a successful call " do
        it "makes a successful call" do
          expect(mock_connection).to receive(:create_applicant) do |estimate_id, params|
            expect(estimate_id).to eq cfe_estimate_id
            expect(params.count).to eq 4
            expect(params).not_to include(:receives_asylum_support)
          end

          service.call(mock_connection, cfe_estimate_id, session_data)
        end
      end

      describe "with controlled and a&I flags enabled", :controlled_flag, :asylum_and_immigration_flag do
        it "makes a successful call" do
          expect(mock_connection).to receive(:create_applicant) do |estimate_id, params|
            expect(estimate_id).to eq cfe_estimate_id
            expect(params.count).to eq 5
            expect(params).to include(:receives_asylum_support)
          end

          service.call(mock_connection, cfe_estimate_id, session_data)
        end
      end
    end
  end
end
