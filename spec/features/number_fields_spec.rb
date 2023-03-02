require "rails_helper"

VALID_INTEGER_VALUES = ["2", "2,000"].freeze
INVALID_INTEGER_VALUES = ["two", "2 00", "2.37"].freeze
INVALID_MONEY_VALUES = ["two", "2 00", "$54"].freeze
VALID_MONEY_VALUES = [
  ["2,000", "2,000"],
  ["2000", "2,000"],
  ["2000.34", "2,000.34"],
  ["£200", "200"],
  ["300.4", "300.40"],
].freeze

RSpec.describe "Number fields" do
  describe "Integer fields" do
    let(:dependant_details_header) { I18n.t("estimate_flow.dependant_details.legend") }

    before do
      visit estimate_build_estimate_path(:foo, :dependant_details)
      choose "Yes", name: "dependant_details_form[child_dependants]"
      choose "No", name: "dependant_details_form[adult_dependants]"
    end

    VALID_INTEGER_VALUES.each do |value|
      it "allows me to proceed if I enter '#{value}' as a value" do
        fill_in "dependant-details-form-child-dependants-count-field", with: value
        click_on "Save and continue"
        expect(page).not_to have_content(dependant_details_header)
      end
    end

    INVALID_INTEGER_VALUES.each do |value|
      it "does not allow me to proceed if I enter '#{value}' as a value" do
        fill_in "dependant-details-form-child-dependants-count-field", with: value
        click_on "Save and continue"
        expect(page).to have_content(dependant_details_header)
        expect(page).to have_css(".govuk-error-summary__list")
      end
    end
  end

  describe "Money fields" do
    before do
      visit "estimates/foo/build_estimates/employment"
      fill_in "employment-form-gross-income-field", with: "5,000"
      fill_in "employment-form-income-tax-field", with: "1000"
      fill_in "employment-form-national-insurance-field", with: "foo"
      choose "Every month"
    end

    INVALID_MONEY_VALUES.each do |value|
      it "shows a validation error if I enter '#{value}'" do
        fill_in "employment-form-national-insurance-field", with: value
        click_on "Save and continue"
        within ".govuk-error-summary__list" do
          expect(page.text).to eq "National Insurance must be a number, if this does not apply enter 0"
        end
      end
    end

    VALID_MONEY_VALUES.each do |pair|
      it "allows me to enter '#{pair[0]}'" do
        fill_in "employment-form-national-insurance-field", with: pair[0]
        click_on "Save and continue"
        expect(page).not_to have_css(".govuk-error-summary__list")
        visit "estimates/foo/build_estimates/employment"
        expect(page).to have_field("employment-form-national-insurance-field", with: pair[1])
      end
    end
  end
end
