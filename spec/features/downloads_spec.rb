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
end
