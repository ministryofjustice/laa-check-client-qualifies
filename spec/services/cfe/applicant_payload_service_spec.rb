require "rails_helper"

RSpec.describe Cfe::ApplicantPayloadService do
  let(:service) { described_class }
  let(:session_data) do
    {
      client_age:,
      passporting: false,
    }.with_indifferent_access
  end
  let(:payload) { {} }

  describe ".call" do
    context "when client is under 60" do
      let(:client_age) { "standard" }

      it "populates the payload appropriately" do
        service.call(session_data, payload, [:applicant])
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
            receives_qualifying_benefit: false,
          },
        )
      end
    end

    context "when client is over 60" do
      let(:client_age) { "over_60" }

      it "populates the payload appropriately" do
        service.call(session_data, payload, [:applicant])
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 70.years.ago.to_date,
            receives_qualifying_benefit: false,
          },
        )
      end
    end

    context "when the client is under 18" do
      let(:client_age) { "under_18" }

      it "populates the payload appropriately" do
        service.call(session_data, payload, [])
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 17.years.ago.to_date,
          },
        )
      end
    end

    context "when a&I matter type is used and client is asylum supported" do
      let(:session_data) do
        {
          immigration_or_asylum_type_upper_tribunal: "immigration_upper",
          asylum_support: true,
          client_age: "standard",
        }.with_indifferent_access
      end

      it "populates the payload appropriately" do
        service.call(session_data, payload, [:asylum_support])
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
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
          client_age: "standard",
          passporting: false,
          partner: false,
        }.with_indifferent_access
      end

      it "populates the payload appropriately" do
        service.call(session_data, payload, %i[applicant asylum_support])
        expect(payload[:applicant]).to eq(
          {
            date_of_birth: 50.years.ago.to_date,
            receives_qualifying_benefit: false,
            receives_asylum_support: false,
          },
        )
      end
    end
  end
end
