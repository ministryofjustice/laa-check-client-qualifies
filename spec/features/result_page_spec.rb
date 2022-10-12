require "rails_helper"

RSpec.describe "Results Page" do
  let(:estimate_id) { "123" }
  let(:mock_connection) do
    instance_double(CfeConnection, api_result: CalculationResult.new(payload), create_applicant: nil)
  end

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit "/estimates/#{estimate_id}/build_estimates/summary"
    click_on "Submit"
  end

  describe "Client income" do
    let(:payload) do
      {
        "success": true,
        "result_summary": {
          "overall_result": {
            "result": "contribution_required",
            "capital_contribution": 2000,
            "income_contribution": 1219.95,
          },
          "disposable_income": {
            "employment_income": {
              "net_employment_income": 123.56,
            },
          },
        },
        "assessment": {
          "gross_income": {
            "irregular_income": {
              "monthly_equivalents": {
                "student_loan": 123.45,
              },
            },
            "state_benefits": {
              "monthly_equivalents": {
                "all_sources": 123.67,
              },
            },
            "other_income": {
              "monthly_equivalents": {
                "all_sources": {
                  "friends_or_family": 123.78,
                  "maintenance_in": 123.79,
                  "property_or_lodger": 123.80,
                  "pension": 123.81,
                },
              },
            },
          },
        },
      }
    end

    it "shows client income information as returned by CFE" do
      expect(page).to have_content "Your client appears provisionally eligible for legal aid based on the information provided."
      expect(page).to have_content "£1,219.95 per month from their disposable income"
      expect(page).to have_content "£2,000.00 from their disposable capital"
      expect(page).to have_content "Employment income £123.56"
      expect(page).to have_content "Benefits received £123.67"
      expect(page).to have_content "Financial help from friends and family £123.78"
      expect(page).to have_content "Maintenance payments from a former partner £123.79"
      expect(page).to have_content "Income from a property or lodger £123.80"
      expect(page).to have_content "Pension £123.81"
      expect(page).to have_content "Student finance £123.45"
    end
  end
end
