require "rails_helper"

RSpec.describe "Outgoings Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time

    visit "/estimates/new"
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)

    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
    click_checkbox("monthly-income-form-monthly-incomes", "none")
    click_on "Save and continue"
  end

  it "handles outgoings" do
    click_checkbox("outgoings-form-outgoings", "housing_payments")
    fill_in "outgoings-form-housing-payments-field", with: "300"
    click_on "Save and continue"
  end
end
