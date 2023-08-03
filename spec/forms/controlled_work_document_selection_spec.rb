require "rails_helper"

RSpec.describe "cw_selection", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) { { "level_of_help" => "controlled", "api_response" => api_response } }
  let(:api_response) { build(:api_result) }

  before do
    set_session(assessment_code, session_data)
    visit "estimates/#{assessment_code}/controlled_work_document_selections/new"
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

  it "lets me start a new check" do
    click_on "Start another eligibility check"
    expect(page).to have_content "What level of help does your client need?"
  end

  context "when MTR phase 1 is in effect" do
    before { travel_to Date.new(2023, 8, 4) }

    it "downloads an updated PDF" do
      expect(YAML).to receive(:load_file).with(Rails.root.join("app/lib/controlled_work_mappings/cw1_and_2_mtr_phase_1.yml")).and_call_original
      choose "CW1&2 - mental health"
      click_on "Download the pre-populated form"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end

  context "when MTR phase 1 is not in effect" do
    before { travel_to Date.new(2023, 6, 4) }

    it "downloads an updated PDF" do
      expect(YAML).to receive(:load_file).with(Rails.root.join("app/lib/controlled_work_mappings/cw1_and_2.yml")).and_call_original
      choose "CW1&2 - mental health"
      click_on "Download the pre-populated form"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
