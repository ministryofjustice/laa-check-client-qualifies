require "rails_helper"

RSpec.describe "Property Page" do
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
      expect(page).to have_content("Please select the option that best decribes your clients property ownership")
    end
  end
end
