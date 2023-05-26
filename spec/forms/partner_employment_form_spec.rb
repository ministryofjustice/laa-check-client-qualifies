require "rails_helper"

RSpec.describe "partner_employment", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, {})
    visit "estimates/#{assessment_code}/build_estimates/partner_employment"
  end

  it "validates against negative net income" do
    fill_in "partner-employment-form-gross-income-field", with: "100"
    fill_in "partner-employment-form-income-tax-field", with: "100"
    fill_in "partner-employment-form-national-insurance-field", with: "50"
    choose("Every month")
    click_on "Save and continue"
    expect(page).to have_content "Gross pay must be more than income tax and National Insurance combined"
  end

  it "validates against blank fields" do
    click_on "Save and continue"
    expect(page).to have_content "Enter gross pay before any deductions"
  end

  it "stores the chosen values in the session" do
    fill_in "partner-employment-form-gross-income-field", with: "100"
    fill_in "partner-employment-form-income-tax-field", with: "50"
    fill_in "partner-employment-form-national-insurance-field", with: "40"
    choose("Every month")
    click_on "Save and continue"

    expect(session_contents["partner_gross_income"]).to eq 100
    expect(session_contents["partner_income_tax"]).to eq 50
    expect(session_contents["partner_national_insurance"]).to eq 40
    expect(session_contents["partner_frequency"]).to eq "monthly"
  end

  context "when the special applicant flag is enabled", :special_applicant_groups_flag do
    it "shows special applicant content" do
      expect(page).to have_content "Partners in prison"
    end

    context "when level of help is certificated" do
      let(:level_of_help) { "certificated" }

      it "shows guidance" do
        expect(page).to have_content "Guidance on clients with police officer partners"
      end
    end
  end
end
