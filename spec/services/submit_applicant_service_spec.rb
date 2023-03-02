require "rails_helper"

RSpec.describe SubmitApplicantService do
  let(:service) { described_class }
  let(:session_data) do
    {
      over_60:,
      employed: false,
      passporting: false,
      partner: false,
    }.with_indifferent_access
  end
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when client is under 60" do
      let(:over_60) { false }

      it "makes a successful call" do
        expect(mock_connection).to receive(:create_applicant).with(
          cfe_assessment_id,
          {
            date_of_birth: 50.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
          },
        )

        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when client is over 60" do
      let(:over_60) { true }

      it "makes a successful call" do
        expect(mock_connection).to receive(:create_applicant).with(
          cfe_assessment_id,
          {
            date_of_birth: 70.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
          },
        )

        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when a&I flag is enabled", :asylum_and_immigration_flag do
      let(:session_data) do
        {
          asylum_support: true,
        }.with_indifferent_access
      end

      it "makes a successful call" do
        expect(mock_connection).to receive(:create_applicant).with(
          cfe_assessment_id,
          {
            date_of_birth: 50.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            receives_asylum_support: true,
          },
        )

        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
