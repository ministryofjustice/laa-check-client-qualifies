require "rails_helper"

RSpec.describe "applicant", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }
  let(:partner_question_placement_hint) do
    "You will be asked questions about the partner after you have answered questions about your client"
  end

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit form_path(:applicant, assessment_code)
  end

  it "shows appropriate error messages if form blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Select yes if your client is aged 60 or over",
        "Select yes if the client has a partner",
        "Select yes if your client receives a passporting benefit or if they are named on their partner's passporting benefit",
      ].join
    end
  end

  it "stores the chosen value in the session" do
    choose "Yes", name: "applicant_form[over_60]"
    choose "Yes", name: "applicant_form[partner]"
    choose "Yes", name: "applicant_form[passporting]"
    click_on "Save and continue"

    expect(session_contents["over_60"]).to eq true
    expect(session_contents["partner"]).to eq true
    expect(session_contents["passporting"]).to eq true
  end

  it "shows help text about prisons" do
    expect(page).to have_content "for example one of them is in prison"
    expect(page).to have_content "Guidance on prisoners"
  end

  context "when the level of help is controlled" do
    let(:level_of_help) { "controlled" }

    it "does not show guidance link" do
      expect(page).not_to have_content "Guidance on prisoners"
    end
  end
end
