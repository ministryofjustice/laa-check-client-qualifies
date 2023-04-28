require "rails_helper"

RSpec.describe "applicant", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit "estimates/#{assessment_code}/build_estimates/applicant"
  end

  it "shows appropriate error messages if form blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Select yes if your client is aged 60 or over",
        "Select if your client is currently employed",
        "Select yes if the client has a partner",
        "Select yes if your client receives a passporting benefit or if they are named on their partner's passporting benefit",
      ].join
    end
  end

  it "stores the chosen value in the session" do
    choose "Yes", name: "applicant_form[over_60]"
    choose "Yes", name: "applicant_form[partner]"
    choose "Employed and in work", name: "applicant_form[employment_status]"
    choose "Yes", name: "applicant_form[passporting]"
    click_on "Save and continue"

    expect(session_contents["over_60"]).to eq true
    expect(session_contents["partner"]).to eq true
    expect(session_contents["employment_status"]).to eq "in_work"
    expect(session_contents["passporting"]).to eq true
  end
end
