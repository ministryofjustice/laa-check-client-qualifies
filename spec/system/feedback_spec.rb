require "rails_helper"

RSpec.describe "Feedback" do
  let(:assessment_code) { :assessment_code }

  before do
    driven_by(:headless_chrome)
  end

  context "when on the results page" do
    it "I can successfully submit satisfaction feedback" do
      # we need to stub the cfe response
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
    end
  end

  context "when on the Start page" do
    it "there is no feedback component" do
      visit root_path
      expect(page).not_to have_content("Give feedback on this page")
    end
  end

  context "when on any other page in the flow" do
    it "I can submit freetext feedback" do
      visit check_answers_path(assessment_code)
      expect(page).to have_content("Give feedback on this page")
      click_on "Give feedback on this page"
      fill_in "text-field", with: "some feedback!"
      click_on "Send"
      expect(page).to have_content("Thank you for your feedback")
    end

    it "I can cancel my freetext feedback" do
      visit check_answers_path(assessment_code)
      expect(page).to have_content("Give feedback on this page")
      click_on "Give feedback on this page"
      fill_in "text-field", with: "some feedback!"
      click_on "Cancel"
      expect(page).to have_content("Give feedback on this page")
      expect(page).not_to have_content("Thank you for your feedback")
    end
  end

  context "when level of help is not yet set" do
    it "I can submit freetext feedback" do
      visit "/what-level-help/#{assessment_code}"
      expect(page).to have_content("Give feedback on this page")
      click_on "Give feedback on this page"
      fill_in "text-field", with: "some more feedback!"
      click_on "Send"
      expect(page).to have_content("Thank you for your feedback")
    end
  end
end
