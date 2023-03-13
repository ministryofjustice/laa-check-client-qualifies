require "rails_helper"

RSpec.describe "vehicle_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/vehicle_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "client-vehicle-details-form-vehicle-value-field", with: "5000"
    choose "Yes", name: "client_vehicle_details_form[vehicle_in_regular_use]"
    choose "No", name: "client_vehicle_details_form[vehicle_over_3_years_ago]"
    choose "Yes", name: "client_vehicle_details_form[vehicle_pcp]"
    check "This asset is a subject matter of dispute"
    fill_in "client-vehicle-details-form-vehicle-finance-field", with: "2000"
    click_on "Save and continue"

    expect(session_contents["vehicle_value"]).to eq 5_000
    expect(session_contents["vehicle_finance"]).to eq 2_000
    expect(session_contents["vehicle_in_regular_use"]).to eq true
    expect(session_contents["vehicle_over_3_years_ago"]).to eq false
    expect(session_contents["vehicle_pcp"]).to eq true
    expect(session_contents["vehicle_in_dispute"]).to eq true
  end

  it "shows SMOD checkbox" do
    expect(page).to have_content(I18n.t("generic.dispute"))
  end

  context "when this is an upper tribunal matter" do
    before do
      set_session(assessment_code, "proceeding_type" => "IM030")
      visit "estimates/#{assessment_code}/build_estimates/vehicle_details"
    end

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end
end
