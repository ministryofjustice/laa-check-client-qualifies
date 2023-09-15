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
    expect(page).to have_current_path(/\A\/which-controlled-work-form/)
  end
end
