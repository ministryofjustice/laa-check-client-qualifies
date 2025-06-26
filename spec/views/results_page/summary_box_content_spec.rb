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
        domestic_abuse_applicant: true,
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
      context "when eligible and there is an upper threshold, and the difference of the total from the threshold, is greater than £1" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 1000) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 989.66,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "shows an appropriate message and doesn't show pence" do
          expect(page_text).to include "£989"
          expect(page_text).to include "Below upper limit (£1,000)"
        end
      end

      context "when eligible and there is an upper threshold, and the difference of the total from the threshold, is 1 pence" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 1000) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 999.99,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "shows an appropriate message and shows pence" do
          expect(page_text).to include "£999.99"
          expect(page_text).to include "Below upper limit (£1,000)"
        end
      end

      context "when eligible and there is an upper threshold, and the difference of the total from the threshold, is within £1 but has no decimals" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 1000) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 999.00,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "does not show decimals" do
          expect(page_text).to include "£999"
          expect(page_text).to include "Below upper limit (£1,000)"
        end
      end

      context "when eligible and there is an upper threshold, and the difference of the total from the threshold, is zero" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 1000) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 1000.00,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "does not show decimals" do
          expect(page_text).to include "Below upper limit (£1,000)"
        end
      end

      context "when eligible and there is no threshold, and the total has no pence" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: nil) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 999.00,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "does not show decimals" do
          expect(page_text).to include "£999"
        end
      end

      context "when eligible and there is no threshold, and the total has pence value" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: nil) }

        let(:result_summary) do
          build(
            :result_summary,
            gross_income: build(
              :gross_income_summary,
              combined_total_gross_income: 999.99,
              proceeding_types: [gross_income_proceeding_type],
            ),
          )
        end

        it "shows the decimals" do
          expect(page_text).to include "£999.99"
        end
      end

      context "when eligible and there is no upper threshold" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "eligible", upper_threshold: 999_999_999_999) }

        it "shows an appropriate message" do
          expect(page_text).to include "No limit in domestic abuse matters"
        end
      end

      context "when ineligible" do
        let(:gross_income_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Exceeds upper limit (£1,000)"
          expect(page_text).not_to include "Your client's total exceeds the gross monthly income upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end

    describe "disposable income box" do
      context "when eligible and there is a lower threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Below lower limit (£500)"
        end
      end

      context "when eligible and there is no lower threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500, upper_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Below upper limit (£500)"
        end
      end

      context "when contribution required and there is an upper threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Between lower limit (£500) and upper limit (£1,000)"
        end
      end

      context "when contribution required and income contribution does not have pence value" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 315, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }
        let(:result_summary) do
          build(
            :result_summary,
            overall_result: {
              result: overall_result,
              income_contribution: 67.00,
              capital_contribution: 0,
            },
            disposable_income: build(
              :disposable_income_summary,
              combined_total_disposable_income: 494.43,
              proceeding_types: [disposable_income_proceeding_type],
            ),
          )
        end

        it "shows an appropriate message, without the pence" do
          expect(page_text).to include "Contribution needed (£67 per month)"
          expect(page_text).to include "Disposable monthly income"\
                                       "£494"
          expect(page_text).to include "Above lower limit (£315)"
        end
      end

      context "when contribution required and income contribution does have some pence value" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 400, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }
        let(:result_summary) do
          build(
            :result_summary,
            overall_result: {
              result: overall_result,
              income_contribution: 23.23,
              capital_contribution: 0,
            },
            disposable_income: build(
              :disposable_income_summary,
              combined_total_disposable_income: 494.43,
              proceeding_types: [disposable_income_proceeding_type],
            ),
          )
        end

        it "shows an appropriate message, without the pence" do
          expect(page_text).to include "Contribution needed (£23.23 per month)"
          expect(page_text).to include "Disposable monthly income"\
                                       "£494"
          expect(page_text).to include "Above lower limit (£400)"
        end
      end

      context "when contribution required but income contribution does not have number, for some reason" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 400, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }
        let(:result_summary) do
          build(
            :result_summary,
            overall_result: {
              result: overall_result,
              income_contribution: nil,
              capital_contribution: 0,
            },
            disposable_income: build(
              :disposable_income_summary,
              combined_total_disposable_income: 494.43,
              proceeding_types: [disposable_income_proceeding_type],
            ),
          )
        end

        it "shows an appropriate message, without any contribution needed" do
          expect(page_text).to include "Contribution needed (Not applicable per month)"
          expect(page_text).to include "Disposable monthly income"\
                                       "£494"
          expect(page_text).to include "Above lower limit (£400)"
        end
      end

      context "when contribution required and there is no upper threshold" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Above lower limit (£500)"
        end
      end

      context "when contribution required and overall result is ineligible" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "ineligible" }

        it "shows an appropriate message" do
          expect(page_text).to include "Between lower limit (£500) and upper limit (£1,000)"
        end
      end

      context "when ineligible" do
        let(:disposable_income_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Exceeds upper limit (£1,000)"
          expect(page_text).not_to include "Your client's total exceeds the disposable monthly income upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end

    describe "capital box" do
      context "when eligible and there is a lower threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Below lower limit (£500)"
        end
      end

      context "when eligible and there is no lower threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "eligible", lower_threshold: 500, upper_threshold: 500) }

        it "shows an appropriate message" do
          expect(page_text).to include "Below upper limit (£500)"
        end
      end

      context "when contribution required and there is an upper threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Between lower limit (£500) and upper limit (£1,000)"
        end
      end

      context "when contribution required and there is no upper threshold" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 999_999_999_999) }
        let(:overall_result) { "contribution_required" }

        it "shows an appropriate message" do
          expect(page_text).to include "Above lower limit (£500)"
        end
      end

      context "when contribution required and overall result is ineligible" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "contribution_required", lower_threshold: 500, upper_threshold: 1000) }
        let(:overall_result) { "ineligible" }

        it "shows an appropriate message" do
          expect(page_text).to include "Between lower limit (£500) and upper limit (£1,000)"
        end
      end

      context "when ineligible" do
        let(:capital_proceeding_type) { build(:proceeding_type, result: "ineligible", upper_threshold: 1000) }

        it "shows an appropriate message" do
          expect(page_text).to include "Exceeds upper limit (£1,000)"
          expect(page_text).not_to include "Your client's total exceeds the disposable capital upper limit (£1,000). This means they are ineligible for legal aid."
        end
      end
    end
  end
end
