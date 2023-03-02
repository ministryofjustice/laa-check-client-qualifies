require "rails_helper"

RSpec.describe "Download result", type: :feature do
  let(:calculation_result) { CalculationResult.new(api_response).tap { _1.level_of_help = "certificated" } }
  let(:api_response) { FactoryBot.build(:api_result, eligible: "eligible") }

  it "gives me a download option" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    allow(CfeService).to receive(:call).and_return(calculation_result)

    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    click_on "Submit"
    click_on "Save this page as a PDF"
    expect(page.response_headers["Content-Type"]).to eq("application/pdf")
  end
end
