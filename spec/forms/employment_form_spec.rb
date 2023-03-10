require "rails_helper"

RSpec.describe "employment", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/employment"
  end

  it "validates against negative net income" do
    fill_in "employment-form-gross-income-field", with: "100"
    fill_in "employment-form-income-tax-field", with: "100"
    fill_in "employment-form-national-insurance-field", with: "50"
    choose("Every month")
    click_on "Save and continue"
    expect(page).to have_content "Gross pay must be more than income tax and National Insurance combined"
  end

  it "validates against blank fields" do
    click_on "Save and continue"
    expect(page).to have_content "Enter gross pay before any deductions"
  end

  it "stores the chosen values in the session" do
    fill_in "employment-form-gross-income-field", with: "100"
    fill_in "employment-form-income-tax-field", with: "50"
    fill_in "employment-form-national-insurance-field", with: "40"
    choose("Every month")
    click_on "Save and continue"

    expect(session_contents["gross_income"]).to eq 100
    expect(session_contents["income_tax"]).to eq 50
    expect(session_contents["national_insurance"]).to eq 40
    expect(session_contents["frequency"]).to eq "monthly"
  end
end
