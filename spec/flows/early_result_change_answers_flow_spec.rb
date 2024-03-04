require "rails_helper"

RSpec.describe "Change answers after early result", :early_eligibility_flag, type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }
  let(:eligibility_banner_content) { "Based on the answers you changed, your client is now within the limit for legal aid" }

  before { travel_to fixed_arbitrary_date }

  def stub_cfe_gross_eligible
    stub_request(:post, %r{assessments\z}).to_return(
      body: FactoryBot.build(:api_result,
                             result_summary: build(:result_summary,
                                                   gross_income: build(:gross_income_summary,
                                                                       proceeding_types: build_list(:proceeding_type, 1, result: "eligible")))).to_json,
      headers: { "Content-Type" => "application/json" },
    )
  end

  def stub_under_18_eligible
    stub_request(:post, %r{assessments\z}).to_return(
      body: FactoryBot.build(:api_result,
                             result_summary: build(:result_summary,
                                                   gross_income: build(:gross_income_summary,
                                                                       proceeding_types: []))).to_json,
      headers: { "Content-Type" => "application/json" },
    )
  end

  context "when starting as ineligible on gross income", :stub_cfe_gross_ineligible do
    # Default to certificated - it's mostly un-interesting
    let(:level_of_help) { "Civil certificated or licensed legal work" }
    let(:with_partner) { "No" }

    before do
      start_assessment
      fill_in_client_age_screen
      fill_in_level_of_help_screen(choice: level_of_help)
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: with_partner)
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      fill_in_income_screen(gross: "2700")
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_ineligible_gross_income_screen(choice: "Go to summary")
      confirm_screen("check_answers")
    end

    context "when becoming eligible" do
      before do
        WebMock.reset!
        stub_cfe_gross_eligible
      end

      it "change answers successfully after early gross income result" do
        within "#table-employment_status" do
          click_on "Change"
        end
        expect(CfeParamBuilders::Employment).not_to receive(:call)
        fill_in_employment_status_screen(choice: "Unemployed")
        confirm_screen("outgoings")
        fill_in_forms_until("check_answers")
        expect(page).to have_content "Client outgoings"
        click_on "Submit"
      end

      it "change employment income successfully after early ineligible gross income result", :stub_cfe_calls do
        within "#table-income" do
          click_on "Change"
        end
        fill_in_income_screen(gross: "1000", frequency: "Every month")
        confirm_screen("outgoings")
      end

      it "change dependants successfully" do
        # Enter just above the threshold - with 5 children we will flip to eligible
        within "#table-dependant_details" do
          click_on "Change"
        end
        fill_in_dependant_details_screen({ child_dependants: "Yes", child_dependants_count: 5 })
        fill_in_dependant_income_screen
        confirm_screen("outgoings")
        expect(page).to have_selector(".govuk-notification-banner")
        expect(page).to have_content(eligibility_banner_content)
        fill_in_forms_until("check_answers")
        click_on "Submit"
        expect(page).to have_current_path(/\A\/check-result/)
      end

      it "displays the flash message when they become eligible" do
        within "#table-income" do
          click_on "Change"
        end
        fill_in_income_screen(gross: "1000", frequency: "Every month")
        confirm_screen("outgoings")
        expect(page).to have_selector(".govuk-notification-banner")
        expect(page).to have_content(eligibility_banner_content)
      end
    end

    context "with an early ineligible gross income result and direct journey to check answers, that remains ineligible" do
      it "change employment income successfully after early ineligible gross income result" do
        within "#table-income" do
          click_on "Change"
        end
        fill_in_income_screen(gross: "2999")
        confirm_screen("check_answers")
      end
    end

    it "change level of help successfully" do
      within "#table-level_of_help" do
        click_on "Change"
      end
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_immigration_or_asylum_screen(choice: "No")
      confirm_screen("check_answers")
    end

    it "does not display the flash when they are still ineligible" do
      within "#table-income" do
        click_on "Change"
      end
      fill_in_income_screen(gross: "2700", frequency: "Every month")
      confirm_screen("check_answers")
      expect(page).not_to have_selector(".govuk-notification-banner")
      expect(page).not_to have_content(eligibility_banner_content)
    end

    it "change matter type successfully" do
      start_assessment
      fill_in_client_age_screen
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      fill_in_income_screen(gross: "3000")
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_ineligible_gross_income_screen(choice: "Go to summary")
      confirm_screen("check_answers")
      within "#table-immigration_or_asylum" do
        click_on "Change"
      end
      fill_in_immigration_or_asylum_screen(choice: "Yes")
      fill_in_immigration_or_asylum_type_screen
      fill_in_asylum_support_screen(choice: "Yes")
      confirm_screen("check_answers")
      expect(page).not_to have_selector(".govuk-notification-banner")
      expect(page).not_to have_content(eligibility_banner_content)
    end

    context "when client is under 18" do
      before do
        WebMock.reset!
        stub_under_18_eligible
      end

      it "change client age to under 18 successfully" do
        within "#table-client_age" do
          click_on "Change"
        end
        fill_in_client_age_screen(choice: "Under 18")
        confirm_screen("check_answers")
      end
    end

    # need these complex interactions to be VCR tests as the outcomes
    # are not easily mocked without bizarre outcomes
    context "with a full-stack VCR environment", :vcr do
      let(:level_of_help) { "Civil controlled work or family mediation" }

      before do
        WebMock.reset!
      end

      it "changes client age to under 18 with income" do
        within "#table-client_age" do
          click_on "Change"
        end
        fill_in_client_age_screen(choice: "Under 18")
        fill_in_under_18_controlled_legal_rep_screen(choice: "No")
        fill_in_aggregated_means_screen(choice: "No")
        fill_in_regular_income_screen(choice: "Yes")

        click_on "Submit"
        expect(page).to have_current_path(/\A\/check-result/)
        # check that result isn't 'your answers have been deleted'
        expect(page).to have_content "Your client's key eligibility totals"
      end

      context "with a partner" do
        let(:name) do
          fill_in_income_screen(gross: "2600")
        end

        let(:with_partner) { "Yes" }

        it "can change to below threshold with partner above and submit correctly" do
          within "#table-income" do
            click_on "Change"
          end

          # make client eligible so partner questions get asked
          name
          fill_in_forms_until(:partner_other_income)
          # tip income over to be ineligible
          fill_in_partner_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every month" })
          confirm_screen("outgoings")
          fill_in_forms_until(:check_answers)
          click_on "Submit"
          expect(page).to have_current_path(/\A\/check-result/)
          # check that result isn't 'your answers have been deleted'
          expect(page).to have_content "Your client's key eligibility totals"
        end
      end
    end
  end

  context "when the cfe result is eligible", :stub_cfe_calls do
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
      fill_in_applicant_screen(passporting: "No")
      expect(page).not_to have_selector(".govuk-notification-banner")
      fill_in_dependant_details_screen
      expect(page).not_to have_selector(".govuk-notification-banner")
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
end
