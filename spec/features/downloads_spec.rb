require "rails_helper"

RSpec.describe "Download result", type: :feature do
  let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

  it "gives me a download option" do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])

    allow(CfeService).to receive(:call).and_return(api_response)

    start_assessment
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    click_on "Save this page as a PDF"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end

  context "when a doing a controlled check" do
    it "gives me a download option", :cw_forms_flag do
      allow(CfeConnection).to receive(:state_benefit_types).and_return([])

      allow(CfeService).to receive(:call).and_return(api_response)

      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      click_on "Save this page as a PDF"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
