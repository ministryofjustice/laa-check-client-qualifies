require "rails_helper"

RSpec.describe "Partner Page" do
  before do
    visit estimate_build_estimate_path "estimate_id", :partner
  end

  let(:applicant_header_with_partner) { I18n.t("estimate_flow.applicant.heading_with_partner") }

  it "shows an appropriate error if I enter nothing" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if the client has a partner")
    end
  end

  it "takes me on to the applicant page" do
    select_boolean_value("partner-form", "partner", true)
    click_on "Save and continue"
    expect(page).to have_content applicant_header_with_partner
  end

  it "retains my answer" do
    select_boolean_value("partner-form", "partner", false)
    click_on "Save and continue"
    click_on "Back"
    expect(find_field("partner-form-partner-field")).to be_checked
  end
end
