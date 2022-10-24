require "rails_helper"

RSpec.describe "Vehicle Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:check_answers_header) { "Check your client and partner answers" }

  before do
    travel_to arbitrary_fixed_time
  end

  describe "accessibility" do
    describe "vehicle form" do
      before do
        visit_vehicle_form
      end

      it "passes accessibility including errors" do
        expect(page).to be_axe_clean
        click_on "Save and continue"
        expect(page).to be_axe_clean
      end
    end

    describe "vehicle value form" do
      before do
        visit_vehicle_form
        visit_value_form
      end

      it "passes accessibility check" do
        expect(page).to be_axe_clean
      end

      it "passes accessibility including errors" do
        click_on "Save and continue"
        expect(page).to be_axe_clean
      end
    end

    describe "vehicle age form" do
      before do
        visit_vehicle_form
        visit_value_form
        visit_age_form
      end

      it "passes accessibility check" do
        expect(page).to be_axe_clean
      end

      it "passes accessibility including errors" do
        click_on "Save and continue"
        expect(page).to be_axe_clean
      end
    end

    describe "vehicle finance form" do
      before do
        visit_vehicle_form
        visit_value_form
        visit_age_form
        visit_finance_form
      end

      it "passes accessibility check" do
        # have to skip aria-allowed-attr for govuk conditional radio buttons.
        expect(page).to be_axe_clean.skipping("aria-allowed-attr")
      end

      it "passes accessibility in error state errors" do
        click_on "Save and continue"
        # have to skip aria-allowed-attr for govuk conditional radio buttons.
        expect(page).to be_axe_clean.skipping("aria-allowed-attr")
      end
    end
  end

  describe "CFE submission" do
    before do
      driven_by(:rack_test)
      visit_vehicle_form
      visit_value_form
      visit_age_form value: 10_000
      visit_finance_form
    end

    it "handles a full submit to CFE" do
      select_boolean_value("vehicle-finance-form", :vehicle_pcp, false)
      click_on "Save and continue"

      expect(page).to have_content "Which assets does your client have?"
      click_checkbox("assets-form-assets", "none")
      click_on "Save and continue"

      expect(page).to have_content check_answers_header
      click_on "Submit"

      expect(page).to have_content "Your client appears provisionally eligible"
    end
  end

  def visit_vehicle_form
    visit_applicant_page
    fill_in_applicant_screen_with_passporting_benefits
    click_on "Save and continue"

    click_checkbox("property-form-property-owned", "none")
    click_on "Save and continue"
  end

  def visit_value_form
    select_boolean_value("vehicle-form", :vehicle_owned, true)
    click_on "Save and continue"
  end

  def visit_age_form(value: 20_000)
    fill_in "vehicle-value-form-vehicle-value-field", with: value
    select_boolean_value("vehicle-value-form", :vehicle_in_regular_use, true)
    click_on "Save and continue"
  end

  def visit_finance_form
    select_boolean_value("vehicle-age-form", :vehicle_over_3_years_ago, true)
    click_on "Save and continue"
  end
end
