require "rails_helper"

RSpec.describe "Case Details Page" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:applicant_page_header) { "About your client" }

  before do
    visit new_estimate_path
  end

  it "has the correct content" do
    expect(page).to have_content "Yes"
  end

  it "can submit a domestic abuse case" do
    select_radio_value("proceeding-type-form", "proceeding-type", "da001")
    click_on "Save and continue"
    expect(page).to have_content applicant_page_header
  end

  it "has readable errors" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if your client is likely to be an applicant in a domestic abuse case")
    end
  end
end
