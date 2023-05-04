require "rails_helper"

RSpec.describe Cfe::BenefitsPayloadService do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 24, 9) }
  let(:service) { described_class }
  let(:payload) { {} }

  before do
    travel_to arbitrary_fixed_time
  end

  describe ".call" do
    context "when it is passed valid weekly data" do
      let(:translated) do
        [{ name: "Child benefit",
           payments:
         [{ date: Date.new(2022, 10, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 10, 17), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 10, 10), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 10, 3), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 26), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 19), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 12), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 5), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 29), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 22), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 15), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 8), amount: 100.to_d, client_id: "" }] }]
      end

      let(:session_data) do
        {
          "receives_benefits" => true,
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_week" },
          ],
        }
      end

      it "populates the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to eq translated
      end
    end

    context "when it is passed valid two-weekly data" do
      let(:translated) do
        [{ name: "Child benefit",
           payments:
         [{ date: Date.new(2022, 10, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 10, 10), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 26), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 12), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 29), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 15), amount: 100.to_d, client_id: "" }] }]
      end

      let(:session_data) do
        {
          "receives_benefits" => true,
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_two_weeks" },
          ],
        }
      end

      it "populates the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to eq translated
      end
    end

    context "when it is passed valid four-weekly data" do
      let(:translated) do
        [{ name: "Child benefit",
           payments:
         [{ date: Date.new(2022, 10, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 26), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 29), amount: 100.to_d, client_id: "" }] }]
      end

      let(:session_data) do
        {
          "receives_benefits" => true,
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_four_weeks" },
          ],
        }
      end

      it "populates the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to eq translated
      end
    end

    context "when it is passed valid monthly data" do
      let(:translated) do
        [{ name: "Child benefit",
           payments:
         [{ date: Date.new(2022, 10, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 24), amount: 100.to_d, client_id: "" }] }]
      end

      let(:session_data) do
        {
          "receives_benefits" => true,
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "monthly" },
          ],
        }
      end

      it "populates the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to eq translated
      end
    end

    context "when it is housing_benefit data" do
      let(:translated) do
        [{ name: "housing_benefit",
           payments:
         [{ date: Date.new(2022, 10, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 9, 24), amount: 100.to_d, client_id: "" },
          { date: Date.new(2022, 8, 24), amount: 100.to_d, client_id: "" }] }]
      end

      let(:session_data) do
        {
          "housing_benefit" => true,
          "housing_benefit_value" => "100",
          "housing_benefit_frequency" => "monthly",
        }
      end

      it "populates the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to eq translated
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "does not populate the payload" do
        service.call(session_data, payload)
        expect(payload[:state_benefits]).to be_nil
      end
    end
  end
end
