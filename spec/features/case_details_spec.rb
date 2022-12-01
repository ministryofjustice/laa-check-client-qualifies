require "rails_helper"

RSpec.describe "Case Details Page", :partner_flag do
  let(:estimate_id) { SecureRandom.uuid }
  let(:dependants_details_page_header) { I18n.t("estimate_flow.dependant_details.legend") }

  before do
    visit new_estimate_path
  end

  it "has the correct content" do
    expect(page).to have_content I18n.t("estimate_flow.applicant.proceeding_type.legend")
  end

  it "can submit a domestic abuse case" do
    select_radio_value("applicant-form", "proceeding-type", "da001")
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, true)
    select_applicant_boolean(:passporting, false)
    select_applicant_boolean(:dependants, true)
    click_on "Save and continue"
    expect(page).to have_content dependants_details_page_header
  end

  it "has readable errors" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if your client is likely to be an applicant in a domestic abuse case")
    end
  end
end
