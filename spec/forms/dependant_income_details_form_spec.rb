require "rails_helper"

RSpec.describe "dependant_income_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session_data) do
    {
      "level_of_help" => "controlled",
      "adult_dependants" => true,
      "adult_dependants_count" => 1,
    }
  end

  before do
    set_session(assessment_code, session_data)
    visit form_path(:dependant_income_details, assessment_code)
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

  context "when I have fewer dependants than dependant incomes" do
    let(:session_data) do
      {
        "level_of_help" => "controlled",
        "adult_dependants" => true,
        "adult_dependants_count" => 2,
        "dependant_incomes" => [
          { "frequency" => "weekly", "amount" => 1 },
          { "frequency" => "weekly", "amount" => 2 },
          { "frequency" => "weekly", "amount" => 3 },
        ],
      }
    end

    it "only shows as many incomes as I have dependants" do
      expect(page).to have_text "Dependant 1"
      expect(page).to have_text "Dependant 2"
      expect(page).not_to have_text "Dependant 3"
    end
  end
end
