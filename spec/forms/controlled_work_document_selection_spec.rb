require "rails_helper"

RSpec.describe "cw_selection", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) { { "level_of_help" => "controlled", "api_response" => api_response, "feature_flags" => FeatureFlags.session_flags } }
  let(:api_response) { build(:api_result) }

  before do
    set_session(assessment_code, session_data)
    visit controlled_work_document_selection_path(assessment_code:)
  end

  it "shows an error message if no value is entered" do
    click_on "Continue to download and finish"
    expect(page).to have_content " Select which form you need"
  end

  it "requires me to choose a language" do
    choose "CW1 - legal help, help at court or family help (lower)"
    click_on "Continue to download and finish"
    expect(page).to have_content "Select which language you need the form in"
  end

  context "when there is pensioner disregard applied" do
    let(:api_response) do
      FactoryBot.build(
        :api_result,
        result_summary: build(
          :result_summary,
          capital: build(:capital_summary,
                         pensioner_disregard_applied: 123),
        ),
      )
    end

    it "shows the alert" do
      expect(page).to have_content "60 or over disregard (also known as the pensioner disregard)"
    end
  end

  context "when there is no pensioner disregard applied" do
    let(:api_response) do
      FactoryBot.build(
        :api_result,
        result_summary: build(
          :result_summary,
          capital: build(:capital_summary,
                         pensioner_disregard_applied: 0),
        ),
      )
    end

    it " does not show the alert when there is no pensioner disregard applied" do
      expect(page).not_to have_content "60 or over disregard (also known as the pensioner disregard)"
    end
  end

  it "allows me to proceed if I make a selection" do
    choose "CW1 - legal help, help at court or family help (lower)"
    choose "English"
    click_on "Continue to download and finish"
    expect(page).to have_content "You've reached the end of this service"
  end

  it "allows me to proceed in Welsh when I select a CW1 form" do
    choose "CW1 - legal help, help at court or family help (lower)"
    choose "Welsh"
    click_on "Continue to download and finish"
    expect(page).to have_content "You've reached the end of this service"
  end

  it "shows the freeform feedback widget" do
    expect(page).to have_content "Give feedback on this page"
  end

  context "when the client is asylum supported" do
    let(:session_data) do
      { "level_of_help" => "controlled",
        "immigration_or_asylum" => true,
        "asylum_support" => true,
        "api_response" => api_response,
        "feature_flags" => FeatureFlags.session_flags }
    end

    it "only shows CW1 and CW2 forms" do
      expect(page).to have_content "CW1 - legal help, help at court or family help (lower)"
      expect(page).to have_content "CW2 (IMM) - immigration"
      expect(page).not_to have_content "CW1&2 - mental health"
      expect(page).not_to have_content "CW5 - help with family mediation"
      expect(page).not_to have_content "CIV Means 7 - family mediation"
    end
  end

  context "when the client is under 18 and the level of help is controlled legal representation", :under_eighteen_flag do
    let(:session_data) do
      { "level_of_help" => "controlled",
        "client_age" => "under_18",
        "controlled_legal_representation" => true,
        "api_response" => api_response }
    end

    it "only shows CW2 and CW1&2 forms" do
      expect(page).not_to have_content "CW1 - legal help, help at court or family help (lower)"
      expect(page).to have_content "CW2 (IMM) - immigration"
      expect(page).to have_content "CW1&2 - mental health"
      expect(page).not_to have_content "CW5 - help with family mediation"
      expect(page).not_to have_content "CIV Means 7 - family mediation"
    end
  end
end
