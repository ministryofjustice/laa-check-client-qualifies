require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Result panel content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }
    let(:check) { Check.new(session_data) }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    context "when viewing controlled work" do
      let(:session_data) do
        {
          level_of_help: "controlled",
          immigration_or_asylum: true,
          immigration_or_asylum_type:,
          asylum_support:,
          api_response:,
        }.with_indifferent_access
      end

      let(:asylum_support) { nil }

      context "when immigration" do
        let(:immigration_or_asylum_type) { "immigration_clr" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support. "\
                                        "This makes them automatically financially eligible for civil controlled work"
          end

          it "shows appropriate scopes and merits" do
            expect(page_text).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support. This makes them automatically financially eligible for civil controlled work relating to legal help and help at court for immigration and asylum proceedings, as well as controlled legal representation in the Immigration and Asylum chamber of the first tier or upper tribunal without income, outgoing and capital calculations."
            expect(page_text).to include "Before you, or a provider of advice or services funded by legal aid, proceed with your client's case, it must also be within scope for legal aid and satisfy the relevant merits criteria set out in the relevant legislation and guidance."
          end

          it "shows relevant legislation and guidance section" do
            expect(page_text).to include "This assessment was made using the rules for controlled work (opens in new tab) and the amendments to these rules (opens in new tab)."
            expect(page_text).to include "Guidance on determining financial eligibility for controlled work and family mediation can be found in the guide to determining controlled work (PDF, 940KB)."
          end

          it "does not show CTA for all other result pages" do
            expect(page_text).not_to include "Complete a controlled work form"
            expect(page_text).not_to include "You will need to complete the relevant controlled work form and keep for your records, along with any evidence provided by your client. Your client’s file may be audited and assessed by the LAA at a later date."
            expect(page_text).not_to include "Download a controlled work form with your answers included"
          end
        end

        context "when not receiving asylum support" do
          let(:asylum_support) { false }

          it "displays the limits table with a lower capital upper threshold" do
            expect(rendered).to include "<td class=\"govuk-table__header\">Capital</td><td class=\"govuk-table__cell\">£3,000</td>"
          end
        end
      end

      context "when asylum" do
        let(:immigration_or_asylum_type) { "asylum" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support. "\
                                        "This makes them automatically financially eligible for civil controlled work"
          end
        end
      end
    end

    context "when viewing certificated work" do
      let(:session_data) do
        {
          level_of_help: "certificated",
          immigration_or_asylum_type_upper_tribunal:,
          asylum_support:,
          api_response:,
        }.with_indifferent_access
      end

      context "when immigration" do
        let(:immigration_or_asylum_type_upper_tribunal) { "immigration_upper" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support, "\
                                        "which makes them automatically financially eligible for civil certificated legal aid"
          end

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end

          it "shows a bespoke evidence list" do
            expect(rendered).to include "confirmation from the Home Office or Migrant Help that the individual is in receipt of support"
          end
        end

        context "when not receiving asylum support" do
          let(:asylum_support) { false }

          it "displays the limits table with a lower capital upper threshold" do
            expect(rendered).to include "<td class=\"govuk-table__header\">Capital</td><td class=\"govuk-table__cell\">£3,000</td>"
          end

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end
        end
      end

      context "when asylum" do
        let(:immigration_or_asylum_type_upper_tribunal) { "asylum_upper" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support, "\
                                        "which makes them automatically financially eligible for civil certificated legal aid"
          end

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end

          it "shows a bespoke evidence list" do
            expect(rendered).to include "confirmation from the Home Office or Migrant Help that the individual is in receipt of support"
          end
        end

        context "when not receiving asylum support" do
          let(:asylum_support) { false }

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end
        end
      end
    end
  end
end
