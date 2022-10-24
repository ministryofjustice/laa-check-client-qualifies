require "rails_helper"

RSpec.describe "Income Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:property_header) { "Your client's property" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:income_header) { "What other income does your client receive?" }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time

    visit_applicant_page
    fill_in_applicant_screen_without_passporting_benefits
    click_on "Save and continue"
    find(:css, "#benefits-form-add-benefit-field").click
    click_on "Save and continue"
  end

  it "shows the correct page" do
    expect(page).to have_content income_header
  end

  it "handles student finance, friends or family and maintenance" do
    click_checkbox("monthly-income-form-monthly-incomes", "student_finance")
    fill_in "monthly-income-form-student-finance-field", with: "100"

    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    fill_in "monthly-income-form-friends-or-family-field", with: "200"
    click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
    fill_in "monthly-income-form-maintenance-field", with: "300"
    click_on "Save and continue"
    expect(page).to have_content("What are your client's monthly outgoings and deductions?")
    progress_to_submit_from_outgoings
  end

  it "behaves appropriately if a field is unchecked after a value is entered" do
    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
    fill_in "monthly-income-form-friends-or-family-field", with: "200"
    click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")

    click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
    fill_in "monthly-income-form-maintenance-field", with: "300"

    click_on "Save and continue"
    # The key expectation of this spec is that the HTTP request to CFE will _not_ include
    # the 200 figure, and this is expressed in the relevant VCR cassette
    expect(page).to have_content("What are your client's monthly outgoings and deductions?")
  end
end
