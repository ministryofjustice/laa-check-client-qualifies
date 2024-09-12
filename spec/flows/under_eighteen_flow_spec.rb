require "rails_helper"

RSpec.describe "Under 18 flow", :stub_cfe_calls_with_webmock, type: :feature do
  let(:clr_text) { "Is the work controlled legal representation" }
  let(:u18_regular_income) { "Does your client get regular income?" }
  let(:u18_assets) { "Does your client have assets worth £2,500 or more?" }

  before do
    start_assessment
  end

  context "with u18 controlled checks" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "No")
    end

    it "shows additional questions" do
      confirm_screen(:check_answers)
      expect(page).to have_content clr_text
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Level of help",
            "Means tests for under 18s",
          ],
        )
    end
  end

  context "with u18 controlled checks with aggregated means" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "Yes")
      fill_in_how_to_aggregate_screen
      fill_in_immigration_or_asylum_screen
      fill_in_applicant_screen
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
    end

    it "hits check answers" do
      confirm_screen(:check_answers)
      expect(page).not_to have_content u18_regular_income
      expect(page).not_to have_content u18_assets
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "with u18 controlled checks with regular income" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "Yes")
      fill_in_immigration_or_asylum_screen
      fill_in_applicant_screen
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
    end

    it "hits check answers" do
      confirm_screen(:check_answers)
      expect(page).not_to have_content u18_assets
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "with u18 controlled checks with assets" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "Yes")
      fill_in_immigration_or_asylum_screen
      fill_in_applicant_screen
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
    end

    it "hits check answers" do
      confirm_screen(:check_answers)
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "with u18 controlled checks with assets and immigration" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "Yes")
      fill_in_immigration_or_asylum_screen(choice: "Yes")
      fill_in_immigration_or_asylum_type_screen
      fill_in_asylum_support_screen
      fill_in_applicant_screen
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
      confirm_screen("check_answers")
    end

    it "hits check answers" do
      confirm_screen(:check_answers)
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Type of immigration or asylum matter",
            "Asylum support",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "when starting with over 18, change answer to u18, and choose 'yes' to CLR" do
    before do
      fill_in_client_age_screen(choice: "18 to 59")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Level of help",
          ],
        )
    end
  end

  context "when starting with over 18, change answer to u18, and choose 'yes' to aggregated means" do
    before do
      fill_in_client_age_screen(choice: "18 to 59")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "Yes")
      fill_in_how_to_aggregate_screen
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "when starting with over 18, change answer to u18, and choose 'yes' to regular income" do
    before do
      fill_in_client_age_screen(choice: "18 to 59")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "Yes")
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "when starting with over 18, change answer to u18, and choose 'yes' to assets" do
    before do
      fill_in_client_age_screen(choice: "18 to 59")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "Yes")
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Partner and passporting",
            "Level of help",
            "Means tests for under 18s",
            "Type of matter",
            "Number of dependants",
            "Employment status",
            "Client benefits",
            "Client other income",
            "Client outgoings and deductions",
            "Home client lives in",
            "Housing costs",
            "Client other property",
            "Client assets",
          ],
        )
    end
  end

  context "when starting with over 18 controlled check that is an immigration matter type, change answer to under 18" do
    before do
      fill_in_client_age_screen(choice: "18 to 59")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_immigration_or_asylum_screen(choice: "Yes")
      fill_in_immigration_or_asylum_type_screen(choice: "Immigration - controlled legal representation (CLR) in the First-tier Tribunal")
      fill_in_asylum_support_screen
      fill_in_forms_until(:check_answers)
      within "#table-client_age" do
        click_on "Change"
      end
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "No")
      fill_in_under_eighteen_assets_screen(choice: "No")
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Level of help",
            "Means tests for under 18s",
          ],
        )
    end
  end

  context "when doing a certificated check" do
    before do
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil certificated")
    end

    it "hits check answers" do
      confirm_screen(:check_answers)
      expect(page).not_to have_content clr_text
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          [
            "Client age",
            "Level of help",
          ],
        )
    end
  end

  it "exits early if means are aggregated for controlled work" do
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "Yes")
    fill_in_how_to_aggregate_screen
    confirm_screen("immigration_or_asylum")
  end

  it "exits to Check your answers if it is Controlled Legal Representation work" do
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
    confirm_screen(:check_answers)
  end

  it "exits early if regular income" do
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end

  it "does not skip to check answers if assets" do
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_under_18_controlled_legal_rep_screen(choice: "No")
    fill_in_aggregated_means_screen(choice: "No")
    fill_in_regular_income_screen(choice: "No")
    fill_in_under_eighteen_assets_screen(choice: "Yes")
    confirm_screen("immigration_or_asylum")
  end
end
