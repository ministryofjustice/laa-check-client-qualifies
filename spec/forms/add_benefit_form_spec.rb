require "rails_helper"

RSpec.describe "benefits/new", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    visit "estimates/#{assessment_code}/benefits/new"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter the amount"
  end

  it "saves what I enter to the session" do
    fill_in "benefit_model[benefit_type]", with: "A"
    fill_in "benefit_model[benefit_amount]", with: "1"
    choose "Every week"
    click_on "Save and continue"
    expect(session_contents.dig("benefits", 0, "benefit_type")).to eq "A"
    expect(session_contents.dig("benefits", 0, "benefit_amount")).to eq 1
    expect(session_contents.dig("benefits", 0, "benefit_frequency")).to eq "every_week"
    expect(session_contents.dig("benefits", 0, "id")).to be_present
  end
end
