require "rails_helper"

RSpec.describe "benefit_details", :calls_cfe_early_returns_not_ineligible, type: :feature do
  before do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])
    start_assessment
    fill_in_forms_until(:benefits)
  end

  context "with check answers" do
    let(:benefit_text) { "Client benefit 1 details" }

    context "with benefits" do
      before do
        fill_in_benefits_screen(choice: "Yes")
        fill_in_forms_until(:benefit_details)
        fill_in_benefit_details_screen
        fill_in_forms_until(:check_answers)
      end

      it "shows benefit details" do
        expect(page).to have_content benefit_text
      end
    end

    context "without benefits" do
      before do
        fill_in_benefits_screen(choice: "No")
        fill_in_forms_until(:check_answers)
      end

      it "shows benefit details" do
        expect(page).not_to have_content benefit_text
      end
    end
  end

  context "when on details screen" do
    before do
      fill_in_benefits_screen(choice: "Yes")
      fill_in_forms_until(:benefit_details)
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content "Enter benefit amount"
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
end
