require "rails_helper"

RSpec.describe "Feedback component" do
  before do
    driven_by(:headless_chrome)
    stub_request(:post, %r{v6/assessments\z}).to_return(
      body: build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )
  end

  describe "satisfaction feedback" do
    context "when on the end of journey page", :welsh_cw_flag do
      it "I can successfully submit satisfaction feedback", :slow do
        start_assessment
        fill_in_client_age_screen
        fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
        fill_in_forms_until(:check_answers)
        click_on "Submit"
        click_on "Continue to CW forms"
        choose "CW1 - legal help, help at court or family help (lower)"
        choose "English"
        click_on "Continue to download and finish"
        expect(page).to have_content("Were you satisfied with this service?")
        click_on "Yes"
        expect(page).to have_content("Your response has been sent, please tell us more")
        # TODO - temp fix for parallel running
        sleep 1
        stored_data = SatisfactionFeedback.find_by(satisfied: "yes", outcome: "eligible", level_of_help: "controlled")
        expect(stored_data).not_to be_nil
        fill_in "comment-field", with: "some feedback!"
        click_on "Send"
        expect(page).to have_content("Thank you for your feedback")
        # TODO - temp fix for parallel running
        sleep 1
        expect(stored_data.reload.comment).to eq "some feedback!"
      end
    end
  end

  describe "Freetext feedback" do
    describe "pages within the question flow" do
      context "when on the check answers page" do
        it "I can submit freetext feedback", :slow do
          start_assessment
          fill_in_forms_until(:check_answers)
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
          # TODO - temp fix for parallel running
          sleep 1
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "check_answers_checks", level_of_help: "certificated")).not_to be_nil
        end

        it "I can cancel my freetext feedback", :slow do
          start_assessment
          fill_in_forms_until(:check_answers)
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Cancel"
          expect(page).to have_content("Give feedback on this page")
          expect(page).not_to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "check_answers_checks", level_of_help: "certificated")).to be_nil
          expect(FreetextFeedback.count).to be(0)
        end

        it "I'm presented with prompt, when I don't enter any text", :slow do
          start_assessment
          fill_in_forms_until(:check_answers)
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: ""
          click_on "Send"
          expect(page).to have_content("Give feedback on this page")
          expect(page).not_to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "", page: "check_answers_checks", level_of_help: "certificated")).to be_nil
          expect(FreetextFeedback.count).to be(0)
        end
      end

      context "when on the results page" do
        it "I can successfully submit freetext feedback", :slow do
          start_assessment
          fill_in_client_age_screen
          fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
          fill_in_forms_until(:check_answers)
          click_on "Submit"
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "show_results", level_of_help: "controlled")).not_to be_nil
        end
      end

      context "when on the CW form selection page" do
        it "I can successfully submit freetext feedback", :slow do
          start_assessment
          fill_in_client_age_screen
          fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
          fill_in_forms_until(:check_answers)
          click_on "Submit"
          click_on "Continue to CW forms"
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "new_controlled_work_document_selections", level_of_help: "controlled")).not_to be_nil
        end
      end
    end

    describe "pages outside the question flow" do
      context "when on the updates page" do
        it "shows the feedback component" do
          visit "/updates"
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "index_updates", level_of_help: nil)).not_to be_nil
        end
      end

      context "when on the help page" do
        it "shows the feedback component" do
          visit "/help"
          expect(page).to have_content("Give feedback on this page")
          click_on "Give feedback on this page"
          fill_in "freetext-input-field", with: "some feedback!"
          click_on "Send"
          expect(page).to have_content("Thank you for your feedback")
          expect(FreetextFeedback.find_by(text: "some feedback!", page: "show_helps", level_of_help: nil)).not_to be_nil
        end
      end

      context "when on the privacy page" do
        it "does not show the feedback component" do
          visit "/privacy"
          expect(page).not_to have_content("Give feedback on this page")
        end
      end

      context "when on the Start page" do
        it "there is no feedback component" do
          visit root_path
          expect(page).not_to have_content("Give feedback on this page")
        end
      end
    end
  end
end
