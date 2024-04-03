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
    travel_to Date.new(2024, 2, 2)
    set_session(assessment_code, session_data)
    visit form_path(:dependant_income_details, assessment_code)
  end

  after do
    travel_back
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

  describe "dependant income limits" do
    context "when there are other page errors for frequency or amount" do
      it "does not trigger the error" do
        fill_in "1-amount", with: "hello world"
        click_on "Save and continue"
        expect(page).not_to have_content "Dependant income must be less than the equivalent of £338.90 per month."
        expect(page).to have_content "Select when the dependant normally gets this income"
        expect(page).to have_content "Income for the dependant must be a number"
      end
    end

    context "when choosing monthly frequency" do
      let(:monthly_limit) { "338.90" }

      it "shows an error message when on the limit" do
        fill_in "1-amount", with: monthly_limit
        choose "1-frequency-monthly"
        click_on "Save and continue"
        expect(page).to have_content "Dependant income must be less than £338.90 per month."
      end

      it "does not show an error message when below the limit" do
        fill_in "1-amount", with: "338.89"
        choose "1-frequency-monthly"
        click_on "Save and continue"
        expect(page).not_to have_content "Dependant income must be less than £338.90 per month."
      end
    end

    context "when choosing three month total frequency" do
      let(:three_month_limit) { "1016.70" }

      it "shows an error message when on the limit" do
        fill_in "1-amount", with: three_month_limit
        choose "1-frequency-three_months"
        click_on "Save and continue"
        expect(page).to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end

      it "does not show an error message when below the limit" do
        fill_in "1-amount", with: "1016.69"
        choose "1-frequency-three_months"
        click_on "Save and continue"
        expect(page).not_to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end
    end

    context "when choosing weekly frequency" do
      let(:weekly_limit) { "78.21" }

      it "shows an error message when on the limit" do
        fill_in "1-amount", with: weekly_limit
        choose "1-frequency-every_week"
        click_on "Save and continue"
        expect(page).to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end

      it "does not show an error message when below the limit" do
        fill_in "1-amount", with: "77.98"
        choose "1-frequency-every_week"
        click_on "Save and continue"
        expect(page).not_to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end
    end

    context "when choosing fortnightly frequency" do
      let(:fortnightly_limit) { "156.42" }

      it "shows an error message when on the limit" do
        fill_in "1-amount", with: fortnightly_limit
        choose "1-frequency-every_two_weeks"
        click_on "Save and continue"
        expect(page).to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end

      it "does not show an error message when below the limit" do
        fill_in "1-amount", with: "155.98"
        choose "1-frequency-every_two_weeks"
        click_on "Save and continue"
        expect(page).not_to have_content "Dependant income must be less than the equivalent of £338.90 per month."
      end
    end
  end
end
