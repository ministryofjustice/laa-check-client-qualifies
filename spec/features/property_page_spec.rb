require "rails_helper"

RSpec.describe "Property Page" do
  let(:property_entry_header) { "How much is your client's home worth?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit "/estimates/new"

    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)
    select_applicant_boolean(:passporting, true)
    click_on "Save and continue"
  end

  it "shows the correct form" do
    expect(page).to have_content property_header
  end

  it "sets error on property form" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select the option that best describes your client's property ownership")
    end
  end

  it "can set property to mortage owned" do
    allow(mock_connection).to receive(:create_properties)

    click_checkbox("property-form-property-owned", "with_mortgage")
    click_on "Save and continue"
    expect(page).to have_content property_entry_header
    fill_in "property-entry-form-house-value-field", with: 100_000
    fill_in "property-entry-form-mortgage-field", with: 50_000
    fill_in "property-entry-form-percentage-owned-field", with: 100
    click_on "Save and continue"
    expect(page).to have_content vehicle_header
  end
end
