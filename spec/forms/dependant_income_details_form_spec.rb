require "rails_helper"

RSpec.describe "dependant_income_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session_data)
    visit "estimates/#{assessment_code}/build_estimates/dependant_income_details"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Enter income the dependant gets"
  end

  it "saves what I enter to the session" do
    fill_in "1-amount", with: "1"
    choose "1-frequency-every_week"
    click_on "Save and continue"
    expect(session_contents.dig("dependant_incomes", 0, "frequency")).to eq "every_week"
    expect(session_contents.dig("dependant_incomes", 0, "amount")).to eq 1
  end

  context "when I have a specific number of dependants" do
    let(:session_data) do
      {
        "level_of_help" => "controlled",
        "adult_dependants" => true,
        "adult_dependants_count" => 2,
        "child_dependants" => true,
        "child_dependants_count" => 3,
      }
    end

    it "tells the JS to hide the add another button at the appropriate point" do
      expect(find("[data-add-another-role=\"add\"]")["data-add-another-maximum"]).to eq "5"
    end
  end
end
