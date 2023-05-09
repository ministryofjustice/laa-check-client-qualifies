require "rails_helper"

RSpec.describe "benefits_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])
    set_session(assessment_code, "level_of_help" => "controlled")
    visit "estimates/#{assessment_code}/build_estimates/benefit_details"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter the amount"
  end

  it "saves what I enter to the session" do
    fill_in "1-type", with: "A"
    fill_in "1-benefit-amount", with: "1"
    choose "1-frequency-every_week"
    click_on "Save and continue"
    expect(session_contents.dig("benefits", 0, "benefit_type")).to eq "A"
    expect(session_contents.dig("benefits", 0, "benefit_amount")).to eq 1
    expect(session_contents.dig("benefits", 0, "benefit_frequency")).to eq "every_week"
  end
end
