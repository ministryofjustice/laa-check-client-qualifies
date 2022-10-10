require "rails_helper"

RSpec.describe "Case Details Page" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }
  let(:applicant_page_header) { "About your client" }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit new_estimate_path
  end

  it "can submit a domestic abuse case" do
    expect(mock_connection).to receive(:create_proceeding_type).with(estimate_id, "DA001")
    click_checkbox("proceeding-type-form-proceeding-type", "da001")
    click_on "Save and continue"
    expect(page).to have_content applicant_page_header
  end

  it "has readable errors" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select a case type")
    end
  end
end
