require "rails_helper"

RSpec.describe "CW Forms", :stub_cfe_calls, type: :feature do
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

  context "when progressing to download and end of journey screen" do
    let(:fixed_arbitrary_time) { Time.zone.local(2023, 2, 15, 14, 23, 21) }

    before do
      allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "eligible")
      travel_to fixed_arbitrary_time
      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
    end

    it "takes me to an end-of-journey page" do
      click_on "Continue to CW forms"
      choose "CW2"
      choose "English"
      click_on "Continue to download and finish"
      expect(page).to have_current_path(/\A\/service-end/)
      click_on "Download your form"
      expect(page.response_headers["Content-Disposition"]).to eq("attachment; filename=\"CW2 2023-02-15 14h23m21s.pdf\"; filename*=UTF-8''CW2%202023-02-15%2014h23m21s.pdf")
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end

    it "gives me a welsh-named CW form" do
      click_on "Continue to CW forms"
      choose "CW2"
      choose "Welsh"
      click_on "Continue to download and finish"
      expect(page).to have_current_path(/\A\/service-end/)
      click_on "Download your form"
      expect(page.response_headers["Content-Disposition"]).to eq("attachment; filename=\"Cy CW2 2023-02-15 14h23m21s.pdf\"; filename*=UTF-8''Cy%20CW2%202023-02-15%2014h23m21s.pdf")
    end
  end
end
