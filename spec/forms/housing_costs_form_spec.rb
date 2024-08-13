require "rails_helper"

RSpec.describe "housing_costs", :calls_cfe_early_returns_not_ineligible, type: :feature do
  let(:level_of_help) { :controlled }

  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(level_of_help)
    fill_in_forms_until(:housing_costs)
  end

  it "performs validations if I enter invalid values" do
    fill_in "housing-costs-form-housing-payments-field", with: "1 1"
    choose "Every 2 weeks", name: "housing_costs_form[housing_payments_frequency]"
    fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
    choose "Every 4 weeks", name: "housing_costs_form[housing_benefit_frequency]"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my housing payments responses in the session" do
    fill_in "housing-costs-form-housing-payments-field", with: "20"
    choose "Every 2 weeks", name: "housing_costs_form[housing_payments_frequency]"
    choose "Yes", name: "housing_costs_form[housing_benefit_relevant]"
    fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
    choose "Every 4 weeks", name: "housing_costs_form[housing_benefit_frequency]"
    click_on "Save and continue"

    expect(session_contents["housing_payments"]).to eq 20
    expect(session_contents["housing_payments_frequency"]).to eq "every_two_weeks"
    expect(session_contents["housing_benefit_value"]).to eq 40
    expect(session_contents["housing_benefit_frequency"]).to eq "every_four_weeks"
  end

  context "when the level of help is certificated" do
    let(:level_of_help) { :certificated }

    it "shows 'Total in last 3 months' radio" do
      fill_in "housing-costs-form-housing-payments-field", with: "2000"
      choose "Total in last 3 months", name: "housing_costs_form[housing_payments_frequency]"
      choose "Yes", name: "housing_costs_form[housing_benefit_relevant]"
      fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
      choose "Every 2 weeks", name: "housing_costs_form[housing_benefit_frequency]"
      click_on "Save and continue"

      expect(session_contents["housing_payments_frequency"]).to eq "total"
    end
  end

  context "when continuing to check answers screen" do
    context "with housing benefit" do
      before do
        fill_in_housing_costs_screen(housing_payments: 20, housing_benefit: 12.67)
        fill_in_forms_until(:check_answers)
      end

      it "shows the conditional reveal answer" do
        expect(page).to have_content "Is Housing Benefit claimed at the home the client lives in?"
        expect(page).to have_content "12.67"
        expect(page).to have_content "Monthly"
      end
    end

    context "without housing benefit" do
      before do
        fill_in_housing_costs_screen(housing_benefit: 0)
        fill_in_forms_until(:check_answers)
      end

      it "shows the conditional reveal answer" do
        expect(page).to have_content "Is Housing Benefit claimed at the home the client lives in?"
        # want to check that 'Housing Benefit: Not Applicable' isn't shown but housing benefit is shown above
        expect(page).not_to have_content "Not applicable"
      end
    end
  end
end
