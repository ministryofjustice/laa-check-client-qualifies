require "rails_helper"

RSpec.describe "property_entry", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/property_entry"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "client-property-entry-form-house-value-field", with: "100000"
    fill_in "client-property-entry-form-percentage-owned-field", with: "10"
    check "This asset is a subject matter of dispute"
    click_on "Save and continue"

    expect(session_contents["house_value"]).to eq 100_000
    expect(session_contents["percentage_owned"]).to eq 10
    expect(session_contents["house_in_dispute"]).to eq true
  end

  context "when client has a partner" do
    before do
      set_session(assessment_code, "partner" => true)
      visit "estimates/#{assessment_code}/build_estimates/property_entry"
      fill_in "client-property-entry-form-house-value-field", with: "100000"
      fill_in "client-property-entry-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify joint ownership" do
      choose "Yes"
      fill_in "client-property-entry-form-joint-percentage-owned-field", with: "20"
      click_on "Save and continue"

      expect(session_contents["joint_ownership"]).to eq true
      expect(session_contents["joint_percentage_owned"]).to eq 20
    end

    it "errors if total ownership is over 100%" do
      choose "Yes"
      fill_in "client-property-entry-form-joint-percentage-owned-field", with: "95"
      click_on "Save and continue"

      expect(page).to have_css(".govuk-error-summary__list")
    end
  end

  context "when client has a mortgage" do
    before do
      set_session(assessment_code, "property_owned" => "with_mortgage")
      visit "estimates/#{assessment_code}/build_estimates/property_entry"
      fill_in "client-property-entry-form-house-value-field", with: "100000"
      fill_in "client-property-entry-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "client-property-entry-form-mortgage-field", with: "50000"
      click_on "Save and continue"

      expect(session_contents["mortgage"]).to eq 50_000
    end
  end

  it "shows SMOD checkbox" do
    expect(page).to have_content(I18n.t("generic.dispute"))
  end

  context "when this is an upper tribunal matter" do
    before do
      set_session(assessment_code, "proceeding_type" => "IM030")
      visit "estimates/#{assessment_code}/build_estimates/property_entry"
    end

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end
end
