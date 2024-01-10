require "rails_helper"

RSpec.describe "Change answers after early result", :vcr, :early_eligibility_flag, type: :feature do
  # let(:ineligible) do
  #   { "version" => "6",
  #     "timestamp" => "2024-01-11T11:39:21.651Z",
  #     "success" => true,
  #     "result_summary" =>
  #       { "overall_result" =>
  #           { "result" => "ineligible",
  #             "capital_contribution" => 0.0,
  #             "income_contribution" => 0.0,
  #             "proceeding_types" =>
  #               [{ "ccms_code" => "SE003",
  #                  "upper_threshold" => 0.0,
  #                  "lower_threshold" => 0.0,
  #                  "result" => "ineligible",
  #                  "client_involvement_type" => "A" }] },
  #         "gross_income" =>
  #           { "total_gross_income" => 18_200.0,
  #             "proceeding_types" =>
  #               [{ "ccms_code" => "SE003",
  #                  "upper_threshold" => 2657.0,
  #                  "lower_threshold" => 0.0,
  #                  "result" => "ineligible",
  #                  "client_involvement_type" => "A" }],
  #             "combined_total_gross_income" => 18_200.0 } } }
  # end

  # let(:eligible) do
  #   { "version" => "6",
  #     "timestamp" => "2024-01-11T11:39:21.651Z",
  #     "success" => true,
  #     "result_summary" =>
  #       { "overall_result" =>
  #           { "result" => "ineligible",
  #             "capital_contribution" => 0.0,
  #             "income_contribution" => 0.0,
  #             "proceeding_types" =>
  #               [{ "ccms_code" => "SE003",
  #                  "upper_threshold" => 0.0,
  #                  "lower_threshold" => 0.0,
  #                  "result" => "ineligible",
  #                  "client_involvement_type" => "A" }] },
  #         "gross_income" =>
  #           { "total_gross_income" => 18_200.0,
  #             "proceeding_types" =>
  #               [{ "ccms_code" => "SE003",
  #                  "upper_threshold" => 2657.0,
  #                  "lower_threshold" => 0.0,
  #                  "result" => "eligible",
  #                  "client_involvement_type" => "A" }],
  #             "combined_total_gross_income" => 18_200.0 } } }
  # end

  def go_to_check_answers_screen_from_early_ineligible_income_check
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed")
    fill_in_income_screen({ gross: "3000" })
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_early_gross_result_screen(choice: "Go to summary")
    confirm_screen("check_answers")
  end

  it "change answers successfully after early gross income result" do
    go_to_check_answers_screen_from_early_ineligible_income_check
    within "#table-employment_status" do
      click_on "Change"
    end
    expect(CfeParamBuilders::Employment).not_to receive(:call)
    fill_in_employment_status_screen(choice: "Unemployed")
    confirm_screen("outgoings")
    fill_in_forms_until("check_answers")
    click_on "Submit"
  end

  it "change employment income successfully after early ineligible gross income result" do
    go_to_check_answers_screen_from_early_ineligible_income_check
    within "#table-income" do
      click_on "Change"
    end
    fill_in_income_screen({ gross: "1000", frequency: "Every month" })
    confirm_screen("outgoings")
  end

  context "with an early ineligible gross income result and direct journey to check answers, that remains ineligible" do
    it "change employment income successfully after early ineligible gross income result" do
      go_to_check_answers_screen_from_early_ineligible_income_check
      within "#table-income" do
        click_on "Change"
      end
      fill_in_income_screen({ gross: "2999" })
      confirm_screen("check_answers")
    end

    it "change level of help successfully" do
      go_to_check_answers_screen_from_early_ineligible_income_check
      within "#table-level_of_help" do
        click_on "Change"
      end
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_immigration_or_asylum_screen(choice: "No")
      confirm_screen("check_answers")
    end

    it "change dependants successfully" do
      # TODO: this test currently an expected fail - we need to add the logic
      start_assessment
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      #  Enter just above the threshold - with 5 children we will flip to eligible
      fill_in_income_screen({ gross: "2700", frequency: "Every month" })
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_early_gross_result_screen(choice: "Go to summary")
      confirm_screen("check_answers")
      within "#table-dependant_details" do
        click_on "Change"
      end
      fill_in_dependant_details_screen({ child_dependants: "Yes", child_dependants_count: 5 })
      fill_in_dependant_income_screen
      confirm_screen("outgoings")
      expect(page).to have_content("Based on the answers you changed, your client is now within the limit for legal aid")
      fill_in_forms_until("check_answers")
      click_on "Submit"
      expect(page).to have_current_path(/\A\/check-result/)
    end

    it "displays the flash message when they become eligible" do
      go_to_check_answers_screen_from_early_ineligible_income_check
      within "#table-income" do
        click_on "Change"
      end
      fill_in_income_screen({ gross: "1000", frequency: "Every month" })
      confirm_screen("outgoings")
      expect(page).to have_content("Based on the answers you changed, your client is now within the limit for legal aid")
    end

    it "does not display the flash when they are still ineligible" do
      go_to_check_answers_screen_from_early_ineligible_income_check
      within "#table-income" do
        click_on "Change"
      end
      fill_in_income_screen({ gross: "2700", frequency: "Every month" })
      confirm_screen("check_answers")
      expect(page).not_to have_content("Based on the answers you changed, your client is now within the limit for legal aid")
    end

    it "change matter type successfully" do
      start_assessment
      fill_in_client_age_screen
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      fill_in_income_screen({ gross: "3000" })
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_early_gross_result_screen(choice: "Go to summary")
      confirm_screen("check_answers")
      within "#table-immigration_or_asylum" do
        click_on "Change"
      end
      fill_in_immigration_or_asylum_screen(choice: "Yes")
      # TODO: do we expect the below to happen? Maybe not...
      # expect(page).to have_content("Based on the answers you changed, your client is now within the limit for legal aid")
      fill_in_immigration_or_asylum_type_screen
      fill_in_asylum_support_screen
      confirm_screen("check_answers")
    end

    it "change client age to under 18 successfully" do
      go_to_check_answers_screen_from_early_ineligible_income_check
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      confirm_screen("check_answers")
    end
  end

  it "does not save my changes if I back out of them" do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Unemployed")
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    check_answers_url = current_path
    within "#table-employment_status" do
      click_on "Change"
    end
    fill_in_employment_status_screen(choice: "Employed")
    visit check_answers_url # simulate clicking 'back' twice from employment details screen
    confirm_screen("check_answers")
    expect(page).to have_content "What is your client's employment status?Unemployed"
  end

  it "can handle a switch from passporting to not" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:check_answers)
    within "#table-applicant" do
      click_on "Change"
    end
    fill_in_applicant_screen(passporting: "No", employed: "Employed and in work")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    fill_in_housing_costs_screen
    confirm_screen("check_answers")
  end

  it "takes me on mini loops" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#table-vehicle" do
      click_on "Change"
    end
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  it "behaves as expected when there are validation errors" do
    start_assessment
    fill_in_forms_until(:check_answers)
    within "#table-assets" do
      click_on "Change"
    end
    fill_in_assets_screen(values: { investments: "" })
    confirm_screen("assets")
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "can handle a switch from certificated domestic abuse to controlled" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_domestic_abuse_applicant_screen(choice: "Yes")
    fill_in_forms_until(:check_answers)
    within "#table-level_of_help" do
      click_on "Change"
    end
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_immigration_or_asylum_screen
    confirm_screen("check_answers")
  end
end
