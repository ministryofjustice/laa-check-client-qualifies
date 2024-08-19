require "rails_helper"

RSpec.describe "Self-employment flow", :stub_cfe_calls_with_webmock, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
  end

  it "asks for all employment details" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen
    fill_in_partner_employment_status_screen(choice: "Employed or self-employed")
    confirm_screen("partner_income")
  end
end
