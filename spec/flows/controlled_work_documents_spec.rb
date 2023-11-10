require "rails_helper"

RSpec.describe "CW Forms", type: :feature do
  it "lets me access the CW form screen after a controlled check" do
    allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "eligible")
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    click_on "Continue to CW forms"
    expect(page).to have_current_path(/\A\/select-cw-form/)
  end

  context "when the end of journey flag is enabled", :end_of_journey_flag do
    it "takes me to an end-of-journey page" do
      allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "eligible")
      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      click_on "Continue to CW forms"
      choose "CW2"
      click_on "Continue to download and finish"
      expect(page).to have_current_path(/\A\/youve-reached-the-end/)
      click_on "Download your form"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
