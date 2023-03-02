require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Eligibility content", :controlled_flag do
    let(:calculation_result) { CalculationResult.new(api_response).tap { _1.level_of_help = level_of_help } }
    let(:estimate) { EstimateModel.from_session(session_data) }

    let(:session_data) do
      {}.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:estimate, estimate)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when eligible for certificated work" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "show eligible" do
        expect(rendered).to include "Your client is likely to qualify for civil legal aid"
      end
    end

    context "when eligible for controlled work" do
      let(:level_of_help) { "controlled" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

      it "shows eligibility message" do
        expect(rendered).to include "Your client is likely to qualify for civil legal aid, for controlled work and family mediation"
      end
    end

    context "when contribution is required" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "contribution_required") }

      it "show eligible" do
        expect(rendered).to include "Your client is likely to qualify for civil legal aid"
      end
    end

    context "when not eligible" do
      let(:level_of_help) { "certificated" }
      let(:api_response) { FactoryBot.build(:api_result, eligible: "ineligible") }

      it "show ineligible" do
        expect(rendered).to include("Your client is not likely to qualify for civil legal aid")
      end
    end
  end
end
