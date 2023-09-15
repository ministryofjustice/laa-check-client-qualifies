require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "CW Forms content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:api_response) { FactoryBot.build(:api_result, eligible: eligibility) }
    let(:check) { Check.new(session_data) }
    let(:session_data) { { api_response:, level_of_help: }.with_indifferent_access }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    context "when viewing controlled work" do
      let(:level_of_help) { "controlled" }

      context "when eligible" do
        let(:eligibility) { "eligible" }

        it "shows relevant next steps content" do
          expect(page_text).to include "You can download a controlled work form with the answers you gave included, or complete the form yourself"
        end

        it "shows a new call to action" do
          expect(page_text).to include "Continue to CW forms"
        end
      end
    end
  end
end
