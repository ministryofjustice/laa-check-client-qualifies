require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Summary box content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new(session_data) }

    let(:session_data) do
      {
        api_response:,
        # While different rules apply for certificated/controlled
        # and domestic_abuse/other, we infer those rules from the api response, not the raw
        # session data. Which is why we don't need to change these values in all the tests below.
        level_of_help: "certificated",
        matter_type: "domestic_abuse",
      }.with_indifferent_access
    end

    let(:api_response) do
      build(
        :api_result,
        result_summary:,
      )
    end

    let(:result_summary) do
      build(
        :result_summary,
        overall_result: { capital_contribution: 543.21, income_contribution: 123.45, result: overall_result },
        gross_income: build(:gross_income_summary, proceeding_types: [gross_income_proceeding_type]),
        disposable_income: build(:disposable_income_summary, proceeding_types: [disposable_income_proceeding_type]),
        capital: build(:capital_summary, proceeding_types: [capital_proceeding_type]),
      )
    end

    let(:gross_income_proceeding_type) { build(:proceeding_type) }
    let(:disposable_income_proceeding_type) { build(:proceeding_type) }
    let(:capital_proceeding_type) { build(:proceeding_type) }
    let(:overall_result) { "eligible" }

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    describe "gross income box" do
      context "when eligible and there is an upper threshold" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is below the gross monthly income upper limit (£1,000)."
        end
      end

      context "when eligible and there is no upper threshold" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 999_999_999_999) }

        it "shows an appropriate message" do
          expect(page_text).to include "There is no gross monthly income limit in domestic abuse matters."
        end
      end

      context "when ineligible" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client's total exceeds the gross monthly income upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end

    describe "disposable income box" do
      context "when eligible and there is a lower threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is below the disposable monthly income lower limit (£500)."
        end
      end

      context "when eligible and there is no lower threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500, upper_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is below the disposable monthly income upper limit (£500)."
        end
      end

      context "when contribution required and there is an upper threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is between the disposable monthly income lower limit (£500) and upper limit (£1,000). "\
                                       "This means they will need to make a contribution of £123.45 per month towards legal aid costs from their disposable monthly income."
        end
      end

      context "when contribution required and there is no upper threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client's total is above the disposable monthly income lower limit (£500). "\
                                       "This means they will need to make a contribution of up to £123.45 per month from their disposable monthly income, depending on the costs of the case."
        end
      end

      context "when contribution required and overall result is ineligible" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "ineligible" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is between the disposable monthly income lower limit (£500) and upper limit (£1,000)."
        end
      end

      context "when ineligible" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client's total exceeds the disposable monthly income upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end

    describe "capital box" do
      context "when eligible and there is a lower threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is below the disposable capital lower limit (£500)."
        end
      end

      context "when eligible and there is no lower threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500, upper_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is below the disposable capital upper limit (£500)."
        end
      end

      context "when contribution required and there is an upper threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is between the disposable capital lower limit (£500) and upper limit (£1,000). "\
                                       "This means they will need to make a contribution of £543.21 towards legal aid costs from their disposable capital."
        end
      end

      context "when contribution required and there is no upper threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client's total is above the disposable capital lower limit (£500). "\
                                       "This means they will need to make a lump sum contribution of up to £543.21 from their disposable capital, depending on the costs of the case."
        end
      end

      context "when contribution required and overall result is ineligible" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "ineligible" }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client’s total is between the disposable capital lower limit (£500) and upper limit (£1,000)."
        end
      end

      context "when ineligible" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Your client's total exceeds the disposable capital upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end
  end
end
