require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "CW Forms content" do
    let(:calculation_result) { CalculationResult.new(api_response).tap { _1.level_of_help = level_of_help } }
    let(:api_response) { FactoryBot.build(:api_result, eligible: eligibility) }
    let(:estimate) { EstimateModel.from_session({}) }

    before do
      assign(:model, calculation_result)
      assign(:estimate, estimate)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when viewing controlled work" do
      let(:level_of_help) { "controlled" }

      context "when eligible" do
        let(:eligibility) { "eligible" }

        context "when feature flag is enabled", :cw_forms_flag do
          it "shows relevant next steps content" do
            expect(page_text).to include "You can download a controlled work form with the answers you gave included, or complete the form yourself"
          end

          it "shows a new call to action" do
            expect(page_text).to include "Continue to CW forms"
          end
        end

        context "when feature flag is not enabled" do
          it "does not show relevant next steps content" do
            expect(page_text).not_to include "You can download a controlled work form with the answers you gave included, or complete the form yourself"
          end

          it "does not show a new call to action" do
            expect(page_text).not_to include "Continue to CW forms"
          end
        end
      end
    end
  end
end
