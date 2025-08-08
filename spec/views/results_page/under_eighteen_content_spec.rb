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

      it "shows appropriate next steps" do
        expect(page_text).to include "To apply for legal aid for your client you must complete a controlled work form and keep it for your records, with any evidence provided by your client. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).to include "Select the relevant controlled work form and we'll add your answers to it when you download it."
      end

      it "shows appropriate scopes and merits" do
        expect(page_text).to include "You told us your client is under 18. This makes them automatically eligible for controlled legal representation (CLR) without a means test."
        expect(page_text).to include "Before you, or a provider of advice or services funded by legal aid, proceed with your client's case, it must also be within scope for legal aid and satisfy the relevant merits criteria set out in the relevant legislation and guidance."
      end

      it "shows relevant legislation and guidance section" do
        expect(page_text).to include "This assessment was made using the rules for controlled work (opens in new tab) and the amendments to these rules (opens in new tab)."
        expect(page_text).to include "Guidance on determining financial eligibility for controlled work and family mediation can be found in the guide to determining controlled work (PDF, 940KB)."
      end

      it "shows an appropriate PDF description" do
        expect(page_text).to include "The PDF will include:the eligibility declarationthe answers you input into this service"
      end

      it "does not show CTA for all other result pages" do
        expect(page_text).not_to include "Complete a controlled work form"
        expect(page_text).not_to include "You will need to complete the relevant controlled work form and keep for your records, along with any evidence provided by your client. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).not_to include "Download a controlled work form with your answers included"
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

      it "shows appropriate next steps" do
        expect(page_text).to include "To apply for legal aid for your client you must complete a controlled work form and keep it for your records, with any evidence provided by your client. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).to include "Select the relevant controlled work form and we'll add your answers to it when you download it."
      end

      it "shows appropriate scopes and merits" do
        expect(page_text).to include "You told us your client is under 18, their means cannot be aggregated with another person's, they don't have assets worth £2,500 or more, and they don't get regular income. This makes them eligible for controlled work and family mediation without a full means test."
        expect(page_text).to include "Before you, or a provider of advice or services funded by legal aid, proceed with your client's case, it must also be within scope for legal aid and satisfy the relevant merits criteria set out in the relevant legislation and guidance."
      end

      it "shows an appropriate PDF description" do
        expect(page_text).to include "The PDF will include:the eligibility declarationthe answers you input into this service"
      end

      it "does not show CTA for all other result pages" do
        expect(page_text).not_to include "Complete a controlled work form"
        expect(page_text).not_to include "You will need to complete the relevant controlled work form and keep for your records, along with any evidence provided by your client. Your client’s file may be audited and assessed by the LAA at a later date."
        expect(page_text).not_to include "Download a controlled work form with your answers included"
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
