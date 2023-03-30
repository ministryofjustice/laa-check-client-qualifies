require "rails_helper"

RSpec.describe "applicant", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/applicant"
  end

  it "shows appropriate error messages if form blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Select yes if your client is likely to be an applicant in a domestic abuse case",
        "Select yes if your client is aged 60 or over",
        "Select if your client is currently employed",
        "Select yes if the client has a partner",
        "Select yes if your client receives a passporting benefit or if they are named on their partner's passporting benefit",
      ].join
    end
  end

  it "stores the chosen value in the session" do
    choose "Yes", name: "applicant_form[legacy_proceeding_type]"
    choose "Yes", name: "applicant_form[over_60]"
    choose "Yes", name: "applicant_form[partner]"
    choose "Employed and in work", name: "applicant_form[employment_status]"
    choose "Yes", name: "applicant_form[passporting]"
    click_on "Save and continue"

    expect(session_contents["legacy_proceeding_type"]).to eq "DA001"
    expect(session_contents["over_60"]).to eq true
    expect(session_contents["partner"]).to eq true
    expect(session_contents["employment_status"]).to eq "in_work"
    expect(session_contents["passporting"]).to eq true
  end

  it "shows a domestic abuse question" do
    expect(page).to have_content "Is your client likely to be the applicant in a domestic abuse matter?"
  end

  it "shows domestic abuse guidance" do
    expect(page).to have_content "Guidance on domestic abuse or violence"
  end

  context "when level of help is explicitly set to 'controlled'" do
    before do
      set_session(assessment_code, { "level_of_help" => "controlled" })
      visit "estimates/#{assessment_code}/build_estimates/employment"
    end

    it "hides domestic abuse question" do
      expect(page).not_to have_content "Is your client likely to be the applicant in a domestic abuse matter?"
    end

    it "hides domestic abuse guidance" do
      expect(page).not_to have_content "Guidance on domestic abuse or violence"
    end
  end

  context "when asylum and immigration feature flag is enabled", :asylum_and_immigration_flag do
    it "hides domestic abuse question" do
      expect(page).not_to have_content "Is your client likely to be the applicant in a domestic abuse matter?"
    end

    it "hides domestic abuse guidance" do
      expect(page).not_to have_content "Guidance on domestic abuse or violence"
    end
  end
end
