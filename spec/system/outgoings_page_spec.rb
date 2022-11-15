require "rails_helper"

RSpec.describe "Outgoings Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time

    visit_applicant_page
    fill_in_applicant_screen_without_passporting_benefits

    click_on "Save and continue"
    complete_dependants_section
    select_boolean_value("benefits-form", :add_benefit, false)
    click_on "Save and continue"
    complete_incomes_screen
  end

  it "handles outgoings" do
    fill_in "outgoings-form-housing-payments-value-field", with: "100"
    fill_in "outgoings-form-childcare-payments-value-field", with: "200"
    fill_in "outgoings-form-legal-aid-payments-value-field", with: "300"
    fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
    find(:css, "#outgoings-form-housing-payments-frequency-every-week-field").click
    find(:css, "#outgoings-form-childcare-payments-frequency-every-two-weeks-field").click
    find(:css, "#outgoings-form-legal-aid-payments-frequency-monthly-field").click
    click_on "Save and continue"
    select_radio_value("property-form", "property-owned", "none")
    click_on "Save and continue"
    select_boolean_value("vehicle-form", :vehicle_owned, false)
    progress_to_submit_from_vehicle_form
  end
end
