require "rails_helper"

RSpec.describe "Feedback component" do
  before do
    driven_by(:headless_chrome)
  end

  describe "satisfaction feedback" do
    before do
      stub_request(:post, %r{v6/assessments\z}).to_return(
        body: build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )
    end

    context "when on the results page" do
      it "I can successfully submit satisfaction feedback" do
        start_assessment
        fill_in_forms_until(:check_answers)
        click_on "Submit"
        expect(page).to have_content("Were you satisfied with this service?")
        click_on "Yes"
        expect(page).to have_content("Thank you for your feedback")
        expect(page).to have_content("Tell us more in our 2 minute survey (opens in new tab)")
      end
    end

    context "when on the CW form selection page" do
      it "I can successfully submit satisfaction feedback" do
        start_assessment
        fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
        fill_in_forms_until(:check_answers)
        click_on "Submit"
        click_on "Continue to CW forms"
        expect(page).to have_content("Were you satisfied with this service?")
        click_on "No"
        expect(page).to have_content("Thank you for your feedback")
        expect(page).to have_content("Tell us more in our 2 minute survey (opens in new tab)")
      end
    end
  end

  context "when on the Start page" do
    it "there is no feedback component" do
      visit root_path
      expect(page).not_to have_content("Give feedback on this page")
    end
  end

  describe "Freetext feedback" do
    describe "pages within the question flow" do
      context "when on the check answers page" do
        it "I can submit freetext feedback" do
          start_assessment
          fill_in_forms_until(:check_answers)
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "text-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
        end

        it "I can cancel my freetext feedback" do
          start_assessment
          fill_in_forms_until(:check_answers)
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "text-field", with: "some feedback!"
          click_on "Cancel"
          expect(page).to have_content("Give feedback on this page")
          expect(page).not_to have_content("Thank you for your feedback")
        end
      end
    end
  end
end
