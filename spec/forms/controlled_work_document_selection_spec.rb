require "rails_helper"

RSpec.describe "cw_selection", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) { { "level_of_help" => "controlled", "api_response" => api_response } }
  let(:api_response) { build(:api_result) }

  before do
    set_session(assessment_code, session_data)
    visit controlled_work_document_selection_path(assessment_code:)
  end

  it "shows an error message if no value is entered" do
    click_on "Download the pre-populated form"
    expect(page).to have_content " Select which form you need"
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

  it "downloads a PDF if I make a selection" do
    choose "CW1 - legal help, help at court or family help (lower)"
    click_on "Download the pre-populated form"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end

  it "creates an analytics event if I make a selection" do
    choose "CW1 - legal help, help at court or family help (lower)"
    click_on "Download the pre-populated form"
    expect(AnalyticsEvent.last.page).to eq "download_cw1"
  end

  context "when the welsh CW feature flag is enabled", :welsh_cw_flag do
    it "requires me to choose a language" do
      choose "CW1 - legal help, help at court or family help (lower)"
      click_on "Download the pre-populated form"
      expect(page).to have_content "Select which language you need the form in"
    end

    it "allows me to proceed in English" do
      choose "CW1 - legal help, help at court or family help (lower)"
      choose "English"
      click_on "Download the pre-populated form"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end

    it "allows me to proceed in Welsh" do
      choose "CW1&2 - mental health"
      choose "Welsh"
      click_on "Download the pre-populated form"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end

  it "lets me start a new check" do
    click_on "Start another eligibility check"
    expect(page).to have_content "What level of help does your client need?"
  end
end
