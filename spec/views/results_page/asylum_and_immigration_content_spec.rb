require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Result panel content", :asylum_and_immigration_flag do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }
    let(:check) { Check.new(session_data) }

    let(:session_data) do
      {
        level_of_help:,
        proceeding_type:,
        asylum_support:,
        api_response:,
      }.with_indifferent_access
    end

    let(:asylum_support) { nil }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when viewing controlled work" do
      let(:level_of_help) { "controlled" }

      context "when immigration" do
        let(:proceeding_type) { "IM030" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support, "\
                                        "which makes them automatically financially eligible for civil controlled work"
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
        end
      end

      context "when asylum" do
        let(:proceeding_type) { "IA031" }

        context "when receiving asylum support" do
          let(:asylum_support) { true }

          it "displays the appropriate result panel content" do
            expect(rendered).to include "You told us your client is in receipt of Section 4 or Section 95 Asylum Support, "\
                                        "which makes them automatically financially eligible for civil controlled work"
          end

          it "shows a bespoke evidence list" do
            expect(rendered).to include "confirmation from the Home Office or Migrant Help that the individual is in receipt of support"
          end
        end
      end
    end

    context "when viewing certificated work" do
      let(:level_of_help) { "certificated" }

      context "when immigration" do
        let(:proceeding_type) { "IM030" }

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

          it "makes no reference to lower limits" do
            expect(rendered).not_to include "lower limit"
          end

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end
        end
      end

      context "when asylum" do
        let(:proceeding_type) { "IA031" }

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

          it "makes no reference to lower limits" do
            expect(rendered).not_to include "lower limit"
          end

          it "makes no reference to Apply" do
            expect(rendered).to include "Use CCMS to start an application for your client."
          end
        end
      end
    end
  end
end
