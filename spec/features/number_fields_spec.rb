require "rails_helper"

VALID_INTEGER_VALUES = ["2", "2,000", "1234   "].freeze
INVALID_INTEGER_VALUES = ["two", "2 00", "2.37", "+2", "-876"].freeze
INVALID_MONEY_VALUES = ["two", "2 00", "$54", "7_00", "123.45e1"].freeze
VALID_MONEY_VALUES = [
  {
    input: "2,000",
    output: "2,000",
    stored: 2000.0,
  },
  {
    input: "2000",
    output: "2,000",
    stored: 2000.0,
  },
  {
    input: "2000.34",
    output: "2,000.34",
    stored: 2000.34,
  },
  {
    input: "£200",
    output: "200",
    stored: 200.0,
  },
  {
    input: "300.4",
    output: "300.40",
    stored: 300.40,
  },
  {
    input: "2000.34 ",
    output: "2,000.34",
    stored: 2000.34,
  },
  {
    input: "1234.56       ",
    output: "1,234.56",
    stored: 1234.56,
  },
  {
    input: "   £321.56  ",
    output: "321.56",
    stored: 321.56,
  },
].freeze

RSpec.describe "Number fields", :household_section_flag do
  describe "Integer fields" do
    let(:dependant_details_header) { I18n.t("estimate_flow.dependant_details.legend") }

    before do
      set_session(:foo, "level_of_help" => "controlled")
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
      set_session(:foo, "level_of_help" => "controlled", "proceeding_type" => "SE003")
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
      it "allows me to enter '#{pair[:input]}'" do
        fill_in "employment-form-national-insurance-field", with: pair[:input]
        click_on "Save and continue"
        expect(session_contents["national_insurance"]).to eq pair[:stored]
        expect(page).not_to have_css(".govuk-error-summary__list")
        visit "estimates/foo/build_estimates/employment"
        expect(page).to have_field("employment-form-national-insurance-field", with: pair[:output])
      end
    end
  end
end
