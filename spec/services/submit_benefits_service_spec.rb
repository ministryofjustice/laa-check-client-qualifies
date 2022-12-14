require "rails_helper"

RSpec.describe SubmitBenefitsService do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 24, 9, 0, 0) }

  let(:service) { described_class }

  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:url) do
    "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/assessments/#{cfe_estimate_id}/state_benefits"
  end
  let!(:stub) do
    stub_request(:post, url).with(body: translated.to_json).to_return(status: 200)
  end

  before do
    travel_to arbitrary_fixed_time
  end

  describe ".call" do
    context "when it is passed valid weekly data" do
      let(:translated) do
        { "state_benefits" =>
      [{ "name" => "Child benefit",
         "payments" =>
         [{ "date" => "2022-10-24", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-10-17", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-10-10", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-10-03", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-26", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-19", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-12", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-05", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-29", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-22", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-15", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-08", "amount" => "100.0", "client_id" => "" }] }] }
      end

      let(:session_data) do
        {
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_week" },
          ],
        }
      end

      it "makes a successful call" do
        service.call(CfeConnection.new, cfe_estimate_id, session_data)
        expect(stub).to have_been_requested
      end
    end

    context "when it is passed valid two-weekly data" do
      let(:translated) do
        { "state_benefits" =>
      [{ "name" => "Child benefit",
         "payments" =>
         [{ "date" => "2022-10-24", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-10-10", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-26", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-12", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-29", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-15", "amount" => "100.0", "client_id" => "" }] }] }
      end

      let(:session_data) do
        {
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_two_weeks" },
          ],
        }
      end

      it "makes a successful call" do
        service.call(CfeConnection.new, cfe_estimate_id, session_data)
        expect(stub).to have_been_requested
      end
    end

    context "when it is passed valid four-weekly data" do
      let(:translated) do
        { "state_benefits" =>
      [{ "name" => "Child benefit",
         "payments" =>
         [{ "date" => "2022-10-24", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-26", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-29", "amount" => "100.0", "client_id" => "" }] }] }
      end

      let(:session_data) do
        {
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "every_four_weeks" },
          ],
        }
      end

      it "makes a successful call" do
        service.call(CfeConnection.new, cfe_estimate_id, session_data)
        expect(stub).to have_been_requested
      end
    end

    context "when it is passed valid monthly data" do
      let(:translated) do
        { "state_benefits" =>
      [{ "name" => "Child benefit",
         "payments" =>
         [{ "date" => "2022-10-24", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-09-24", "amount" => "100.0", "client_id" => "" },
          { "date" => "2022-08-24", "amount" => "100.0", "client_id" => "" }] }] }
      end

      let(:session_data) do
        {
          "benefits" => [
            { "benefit_amount" => "100",
              "benefit_type" => "Child benefit",
              "benefit_frequency" => "monthly" },
          ],
        }
      end

      it "makes a successful call" do
        service.call(CfeConnection.new, cfe_estimate_id, session_data)
        expect(stub).to have_been_requested
      end
    end
  end
end
