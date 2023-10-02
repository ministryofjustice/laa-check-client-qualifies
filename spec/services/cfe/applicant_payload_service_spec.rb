require "rails_helper"

RSpec.describe Cfe::ApplicantPayloadService do
  let(:service) { described_class }
  let(:session_data) do
    {
      over_60:,
      employment_status: "unemployed",
      passporting: false,
      partner: false,
    }.with_indifferent_access
  end
  let(:payload) { {} }

  describe ".call" do
    context "when client is under 60" do
      let(:over_60) { false }

      it "populates the payload appropriately" do
        service.call(session_data, payload)
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            receives_asylum_support: false,
          },
        )
      end
    end

    context "when client is over 60" do
      let(:over_60) { true }

      it "populates the payload appropriately" do
        service.call(session_data, payload)
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 70.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            receives_asylum_support: false,
          },
        )
      end
    end

    context "when a&I matter type is used and client is asylum supported" do
      let(:session_data) do
        {
          immigration_or_asylum_type_upper_tribunal: "immigration_upper",
          asylum_support: true,
        }.with_indifferent_access
      end

      it "populates the payload appropriately" do
        service.call(session_data, payload)
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            receives_asylum_support: true,
          },
        )
      end
    end

    context "when a&I matter type is used and client is not asylum supported" do
      let(:session_data) do
        {
          immigration_or_asylum_type_upper_tribunal: "immigration_upper",
          asylum_support: false,
          over_60: false,
          employment_status: "unemployed",
          passporting: false,
          partner: false,
        }.with_indifferent_access
      end

      it "populates the payload appropriately" do
        service.call(session_data, payload)
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
            employed: false,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            receives_asylum_support: false,
          },
        )
      end
    end
  end
end
