require "rails_helper"

RSpec.describe "Check Answers Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  it "has no AXE-detectable accessibility issues" do
    travel_to arbitrary_fixed_time

    visit_check_answers
    expect(page).to be_axe_clean
  end

  def visit_check_answers
    visit_applicant_page
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)

    select_applicant_boolean(:passporting, true)
    click_on "Save and continue"

    click_checkbox("property-form-property-owned", "none")
    click_on "Save and continue"

    select_boolean_value("vehicle-form", :vehicle_owned, false)
    click_on "Save and continue"

    click_checkbox("assets-form-assets", "none")
    click_on "Save and continue"
  end
end
