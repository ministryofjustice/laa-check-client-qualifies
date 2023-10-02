require "rails_helper"

RSpec.describe "Download result", type: :feature do
  let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

  it "gives me a download option for an eligible certificated check" do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])

    allow(CfeService).to receive(:call).and_return(api_response)

    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    click_on "Save results and answers as a printable PDF"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end

  it "gives me a download option for an eligible controlled check" do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])

    allow(CfeService).to receive(:call).and_return(api_response)

    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    click_on "Save results and answers as a printable PDF"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end

  context "when the applicant is ineligible" do
    let(:api_response) { FactoryBot.build(:api_result, eligible: "ineligible") }

    it "gives me a download option for a certificated check" do
      allow(CfeConnection).to receive(:state_benefit_types).and_return([])

      allow(CfeService).to receive(:call).and_return(api_response)

      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      click_on "Save results and answers as a printable PDF"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end

    it "gives me a download option for a controlled check" do
      allow(CfeConnection).to receive(:state_benefit_types).and_return([])

      allow(CfeService).to receive(:call).and_return(api_response)

      start_assessment
      fill_in_forms_until(:level_of_help)
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      click_on "Save results and answers as a printable PDF"
      expect(page.response_headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
