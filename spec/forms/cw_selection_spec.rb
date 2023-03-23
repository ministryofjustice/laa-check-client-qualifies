require "rails_helper"

RSpec.describe "cw_selection", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/cws/new"
  end

  it "shows an error message if no value is entered" do
    click_on "Download the pre-populated form"
    expect(page).to have_content " Select which form you need"
  end

  it "downloads a PDF if I make a selection" do
    choose "CW1 - legal help, help at court or family help (lower)"
    click_on "Download the pre-populated form"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end

  it "lets me start a new check" do
    click_on "Start another eligibility check"
    expect(page).to have_content "About your client"
  end
end
