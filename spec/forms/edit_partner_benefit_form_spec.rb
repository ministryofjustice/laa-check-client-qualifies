require "rails_helper"

RSpec.describe "partner_benefits/new", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:benefit_id) { "benefit_id" }

  before do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    set_session(assessment_code, "partner_benefits" => [
      {
        "id" => benefit_id,
        "benefit_frequency" => "every_week",
        "benefit_amount" => 1,
        "benefit_type" => "A",
      },
    ])
    visit "estimates/#{assessment_code}/partner_benefits/#{benefit_id}/edit"
  end

  it "shows an error message if values are deleted" do
    fill_in "partner_benefit_model[benefit_amount]", with: ""
    click_on "Save and continue"
    expect(page).to have_content "Enter the amount"
  end

  it "saves what I enter to the session" do
    fill_in "partner_benefit_model[benefit_type]", with: "B"
    fill_in "partner_benefit_model[benefit_amount]", with: "2"
    choose "Every 2 weeks"
    click_on "Save and continue"
    expect(session_contents.dig("partner_benefits", 0, "benefit_type")).to eq "B"
    expect(session_contents.dig("partner_benefits", 0, "benefit_amount")).to eq 2
    expect(session_contents.dig("partner_benefits", 0, "benefit_frequency")).to eq "every_two_weeks"
    expect(session_contents.dig("partner_benefits", 0, "id")).to eq benefit_id
  end
end
