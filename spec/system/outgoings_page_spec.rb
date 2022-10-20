require "rails_helper"

RSpec.describe "Outgoings Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time

    visit_applicant_page
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:employed, false)

    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    fill_in "monthly-income-form-friends-or-family-field", with: "100"
    click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
    fill_in "monthly-income-form-maintenance-field", with: "200"
    click_checkbox("monthly-income-form-monthly-incomes", "property_or_lodger")
    fill_in "monthly-income-form-property-or-lodger-field", with: "300"
    click_checkbox("monthly-income-form-monthly-incomes", "pension")
    fill_in "monthly-income-form-pension-field", with: "400"
    click_checkbox("monthly-income-form-monthly-incomes", "other")
    fill_in "monthly-income-form-other-field", with: "500"
    click_on "Save and continue"
  end

  it "handles outgoings" do
    click_checkbox("outgoings-form-outgoings", "housing_payments")
    fill_in "outgoings-form-housing-payments-field", with: "300"
    click_on "Save and continue"
    click_checkbox("property-form-property-owned", "none")
    click_on "Save and continue"
    select_boolean_value("vehicle-form", :vehicle_owned, false)
    progress_to_submit_from_vehicle_form
  end
end
