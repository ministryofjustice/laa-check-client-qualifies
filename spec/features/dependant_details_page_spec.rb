require "rails_helper"

VALID_INTEGER_VALUES = ["2", "2,000"].freeze
INVALID_INTEGER_VALUES = ["two", "2 00", "2.37"].freeze

RSpec.describe "Dependant details page" do
  let(:dependant_details_header) { I18n.t("estimate_flow.combined_dependant_details.legend") }

  before do
    visit_first_page
    fill_in_applicant_screen_without_passporting_benefits
    click_on "Save and continue"
  end

  VALID_INTEGER_VALUES.each do |value|
    it "allows me to proceed if I enter '#{value}' as a value" do
      select_boolean_value("dependant-details-form", :child_dependants, true)
      select_boolean_value("dependant-details-form", :adult_dependants, false)
      fill_in "dependant-details-form-child-dependants-count-field", with: value
      click_on "Save and continue"
      expect(page).not_to have_content(dependant_details_header)
    end
  end

  INVALID_INTEGER_VALUES.each do |value|
    it "does not allow me to proceed if I enter '#{value}' as a value" do
      select_boolean_value("dependant-details-form", :child_dependants, true)
      select_boolean_value("dependant-details-form", :adult_dependants, false)
      fill_in "dependant-details-form-child-dependants-count-field", with: value
      click_on "Save and continue"
      expect(page).to have_content(dependant_details_header)
      expect(page).to have_css(".govuk-error-summary__list")
    end
  end
end
