require "rails_helper"

RSpec.describe "Asylum support checks", type: :feature do
  before do
    start_assessment
    fill_in_level_of_help_screen(choice: "Civil certificated")
    fill_in_domestic_abuse_applicant_screen(choice: "No")
    fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "Yes, asylum (Upper Tribunal)")
    fill_in_asylum_support_screen(choice: "Yes")
  end

  context "with stubbing" do
    let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

    before { travel_to fixed_arbitrary_date }

    it "sends the right data to CFE for certificated work" do
      stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)
        expect(parsed["assessment"]).to eq({
          "submission_date" => "2023-02-15",
          "level_of_help" => "certificated",
        })
        expect(parsed["proceeding_types"]).to eq([{ "ccms_code" => "IA031", "client_involvement_type" => "A" }])
        expect(parsed["applicant"]).to eq({
          "date_of_birth" => "1973-02-15",
          "has_partner_opponent" => false,
          "receives_qualifying_benefit" => false,
          "employed" => false,
          "receives_asylum_support" => true,
        })
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      click_on "Submit"
      expect(stubbed_assessment_call).to have_been_requested
    end
  end

  context "when hitting the API", :end2end do
    it "renders content" do
      click_on "Submit"
      expect(page).to have_content("Your client is likely to qualify for civil legal aid, for certificated work")
      expect(page).not_to have_content("Income calculation")
      expect(page).not_to have_content("Outgoings calculation")
      expect(page).not_to have_content("Capital calculation")
    end
  end
end
