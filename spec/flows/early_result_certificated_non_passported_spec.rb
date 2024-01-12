require "rails_helper"

RSpec.describe "Early Result Certificated, non-passported flow", :early_eligibility_flag, type: :feature do
  let(:api_response) do
    { "version" => "6",
      "timestamp" => "2024-01-11T11:39:21.651Z",
      "success" => true,
      "result_summary" =>
        { "overall_result" =>
            { "result" => "ineligible",
              "capital_contribution" => 0.0,
              "income_contribution" => 0.0,
              "proceeding_types" =>
                [{ "ccms_code" => "SE003",
                   "upper_threshold" => 0.0,
                   "lower_threshold" => 0.0,
                   "result" => "ineligible",
                   "client_involvement_type" => "A" }] },
          "gross_income" =>
            { "total_gross_income" => 18_200.0,
              "proceeding_types" =>
                [{ "ccms_code" => "SE003",
                   "upper_threshold" => 2657.0,
                   "lower_threshold" => 0.0,
                   "result" => "ineligible",
                   "client_involvement_type" => "A" }],
              "combined_total_gross_income" => 18_200.0 } } }
  end

  it "when I am ineligible on gross income and continue the check" do
    allow(CfeService).to receive(:call).and_return(api_response)

    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen({ gross: "8000", frequency: "Every month" })
    fill_in_forms_until(:other_income)
    fill_in_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every week" })
    bypass_early_gross_income_result("Return to check")
    confirm_screen("outgoings")
    fill_in_outgoings_screen
  end

  it "when I am ineligible on gross income and stop the check", :early_eligibility_flag do
    allow(CfeService).to receive(:call).and_return(api_response)

    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen({ gross: "8000", frequency: "Every month" })
    fill_in_forms_until(:other_income)
    fill_in_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every week" })
    bypass_early_gross_income_result("Check answers")
    confirm_screen("check_answers")
  end
end
