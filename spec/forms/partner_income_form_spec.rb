require "rails_helper"

RSpec.describe "partner_income", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) { { "level_of_help" => level_of_help, "partner" => true } }
  let(:level_of_help) { "controlled" }
  let(:annual_option) { "Total in the last year" }

  before do
    set_session(assessment_code, session_data)
    visit form_path(:partner_income, assessment_code)
  end

  it "has no annual option" do
    expect(page).not_to have_content annual_option
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter the income before any deductions"
  end

  it "validates gross pay exceeds deductions" do
    choose "A salary or wage", name: "income_model[items][1][income_type]"
    choose "Every week", name: "income_model[items][1][income_frequency]"
    fill_in "income_model[items][1][gross_income]", with: "1"
    fill_in "income_model[items][1][income_tax]", with: "1"
    fill_in "income_model[items][1][national_insurance]", with: "1"
    click_on "Save and continue"
    expect(page).to have_content "Income before any deductions must be more than income tax and National Insurance combined"
  end

  it "saves what I enter to the session" do
    choose "A salary or wage", name: "income_model[items][1][income_type]"
    choose "Every week", name: "income_model[items][1][income_frequency]"
    fill_in "income_model[items][1][gross_income]", with: "123"
    fill_in "income_model[items][1][income_tax]", with: "22"
    fill_in "income_model[items][1][national_insurance]", with: "11"
    click_on "Save and continue"
    expect(session_contents.dig("partner_incomes", 0, "gross_income")).to eq 123
    expect(session_contents.dig("partner_incomes", 0, "income_tax")).to eq 22
    expect(session_contents.dig("partner_incomes", 0, "national_insurance")).to eq 11
    expect(session_contents.dig("partner_incomes", 0, "income_type")).to eq "employment"
    expect(session_contents.dig("partner_incomes", 0, "income_frequency")).to eq "every_week"
  end

  context "when this is a certificated check" do
    let(:level_of_help) { "certificated" }

    it "has an annual option" do
      expect(page).to have_content annual_option
    end

    it "saves what I enter to the session" do
      choose "A salary or wage", name: "income_model[items][1][income_type]"
      choose annual_option, name: "income_model[items][1][income_frequency]"
      fill_in "income_model[items][1][gross_income]", with: "123"
      fill_in "income_model[items][1][income_tax]", with: "22"
      fill_in "income_model[items][1][national_insurance]", with: "11"
      click_on "Save and continue"
      expect(session_contents.dig("partner_incomes", 0, "income_frequency")).to eq "year"
    end
  end
end
