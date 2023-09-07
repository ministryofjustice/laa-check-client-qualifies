require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Eligibility content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }

    let(:session_data) do
      {
        api_response:,
        level_of_help:,
      }.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    context "when eligible for certificated work" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "show eligible" do
        expect(page_text).to include "Your client is likely to qualify for civil legal aid"
      end
    end

    context "when eligible for controlled work" do
      let(:level_of_help) { "controlled" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "shows eligibility message" do
        expect(page_text).to include "Your client qualifies for civil legal aid, for controlled work and family mediation"
      end
    end

    context "when contribution is required" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "contribution_required") }

      it "show eligible" do
        expect(page_text).to include "Your client is likely to qualify for civil legal aid"
      end
    end

    context "when not eligible" do
      let(:level_of_help) { "certificated" }
      let(:api_response) do
        FactoryBot.build(
          :api_result,
          eligible: "ineligible",
          result_summary: {
            overall_result: {
              result: "ineligible",
            },
            gross_income: {
              proceeding_types: [
                { "ccms_code": "SE003",
                  "client_involvement_type": "I",
                  "upper_threshold": 2657.0,
                  "lower_threshold": 0.0,
                  "result": "ineligible" },
              ],
            },
            disposable_income: {
              proceeding_types: [
                { "result": "pending" },
              ],
            },
            capital: {
              proceeding_types: [
                { "result": "pending" },
              ],
            },
          },
        )
      end

      it "show ineligible" do
        expect(page_text).to include(
          "Your client’s total monthly income exceeds the upper limit. This means they do not qualify for legal aid.",
        )
        expect(page_text).to include("Your client is not likely to qualify for civil legal aid")
      end
    end
  end
end
