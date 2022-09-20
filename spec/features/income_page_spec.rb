require "rails_helper"

RSpec.describe "Income Page" do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:property_header) { "Your client's property" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:income_header) { "What income does your client receive?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit "/estimates/new"
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)

    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
  end

  it "shows the correct page" do
    expect(page).to have_content income_header
  end

  it "validates presence of a checked field" do
    click_checkbox("monthly-income-form-monthly-incomes", "employment_income")
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("can't be blank")
    end
  end

  it "validates that at least one field is checked" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select at least one option")
    end
  end
end
