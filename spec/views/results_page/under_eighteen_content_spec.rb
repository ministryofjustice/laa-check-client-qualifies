require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Result panel content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }
    let(:check) { Check.new(session_data) }
    let(:journey_continues_on_another_page) { true }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      assign(:journey_continues_on_another_page, journey_continues_on_another_page)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    context "when under-18 CLR check" do
      let(:session_data) do
        {
          level_of_help: "controlled",
          client_age: "under_18",
          controlled_legal_representation: true,
          api_response:,
        }.with_indifferent_access
      end

      it "displays the appropriate result panel content" do
        expect(page_text).to include "Your client qualifies for civil legal aid without a means test, for controlled legal representation"
      end

      it "shows an appropriate PDF description" do
        expect(page_text).to include "The PDF will include:the eligibility declarationthe answers you input into this service"
      end

      it "shows appropriate next steps" do
        expect(page_text).to include "You will need to complete the relevant controlled work form and keep for your records. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).to include "Download a controlled work form with your answers included"
      end
    end

    context "when under-18 non-means controlled check" do
      let(:session_data) do
        {
          level_of_help: "controlled",
          client_age: "under_18",
          controlled_legal_representation: false,
          aggregated_means: false,
          regular_income: false,
          under_eighteen_assets: false,
          api_response:,
        }.with_indifferent_access
      end

      it "displays the appropriate result panel content" do
        expect(page_text).to include "Your client qualifies for civil legal aid without a full means test, for controlled work and family mediation"
      end

      it "shows an appropriate PDF description" do
        expect(page_text).to include "The PDF will include:the eligibility declarationthe answers you input into this service"
      end

      it "shows appropriate next steps" do
        expect(page_text).to include "You will need to complete the relevant controlled work form and keep for your records. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).to include "Download a controlled work form with your answers included"
      end
    end

    context "when under-18 certificated check" do
      let(:journey_continues_on_another_page) { false }
      let(:session_data) do
        {
          level_of_help: "certificated",
          client_age: "under_18",
          api_response:,
        }.with_indifferent_access
      end

      it "displays the appropriate result panel content" do
        expect(page_text).to include "Your client qualifies for civil legal aid without a means test, for certificated work"
      end

      it "shows an appropriate PDF description" do
        expect(page_text).to include "The PDF will include:the eligibility declarationthe answers you input into this service"
      end

      it "shows appropriate next steps" do
        expect(page_text).to include "Use Apply for legal aid or CCMS to start an application for your client."
      end
    end
  end
end
