require "rails_helper"

RSpec.describe "Benefits page" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }
  let(:income_header) { "What other income does your client receive?" }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    visit_applicant_page

    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)
    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
  end

  context "without an answer" do
    before do
      click_on "Save and continue"
    end

    it "errors nicely" do
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Select yes if your client receives benefits")
      end
    end
  end

  context "without benefits" do
    before do
      select_boolean_value("benefit-yesno-form", :has_benefits, false)
      click_on "Save and continue"
    end

    it "skips benefits questions" do
      expect(page).to have_content income_header
    end
  end

  context "with benefits" do
    before do
      select_boolean_value("benefit-yesno-form", :has_benefits, true)
      click_on "Save and continue"
    end

    it "handles errors" do
      click_on "Save and continue"

      within ".govuk-error-summary__list" do
        expect(page).to have_content("Please enter a benefit type")
        expect(page).to have_content("Please enter a benefit amount")
        expect(page).to have_content("Please select a benefit frequency")
      end
    end

    it "handles non numeric values of amount" do
      fill_in "benefit-details-form-benefit-type-field", with: "Child Benefit"
      fill_in "benefit-details-form-benefit-amount-field", with: "xx"
      click_checkbox "benefit-details-form", "benefit-frequency-2"
      click_on "Save and continue"

      within ".govuk-error-summary__list" do
        expect(page).to have_content("Benefit amount must be greater than £0")
      end
    end

    context "with 1 benefit pre-filled" do
      before do
        fill_in "benefit-details-form-benefit-type-field", with: "Child Benefit"
        fill_in "benefit-details-form-benefit-amount-field", with: "102.34"
        click_checkbox "benefit-details-form", "benefit-frequency-2"
        click_on "Save and continue"
      end

      it "can remove a benefit" do
        click_on "Remove"
        expect(page).to have_content "You have added 0 benefits"
      end

      it "can edit a benefit" do
        click_on "Edit"
        fill_in "benefit-details-form-benefit-type-field", with: "Coconut Benefit"
        click_on "Save and continue"
        expect(page).to have_content "You have added 1 benefits"
        expect(page).to have_content "Coconut Benefit"
      end

      it "errors on the more field" do
        click_on "Save and continue"

        within ".govuk-error-summary__list" do
          expect(page).to have_content("Select yes to add another benefit")
        end
      end

      it "handles two benefits" do
        expect(mock_connection)
          .to receive(:create_benefits)
                .with(estimate_id,
                      [{ benefit_amount: 102.34, benefit_frequency: 2, benefit_type: "Child Benefit" },
                       { benefit_amount: 98.04, benefit_frequency: 1, benefit_type: "Coconut Benefit" }])

        select_boolean_value("benefit-more-form", :more_benefits, true)
        click_on "Save and continue"

        fill_in "benefit-details-form-benefit-type-field", with: "Coconut Benefit"
        fill_in "benefit-details-form-benefit-amount-field", with: "98.04"
        click_checkbox "benefit-details-form", "benefit-frequency-1"
        click_on "Save and continue"

        expect(page).to have_content "You have added 2 benefits"
        select_boolean_value("benefit-more-form", :more_benefits, false)
        click_on "Save and continue"

        expect(page).to have_content income_header
      end

      it "handles a single benefit" do
        expect(mock_connection)
          .to receive(:create_benefits)
                .with(estimate_id,
                      [{ benefit_amount: 102.34, benefit_frequency: 2, benefit_type: "Child Benefit" }])

        expect(page).to have_content "You have added 1 benefits"
        expect(page).to have_content "Child Benefit"
        select_boolean_value("benefit-more-form", :more_benefits, false)
        click_on "Save and continue"
        expect(page).to have_content income_header
      end
    end
  end
end
