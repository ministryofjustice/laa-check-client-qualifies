require "rails_helper"

RSpec.shared_context "with passported attributes", :household_section_flag do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
  end

  def submit_data_to_cfe
    choose "No", name: "applicant_form[over_60]"
    choose "No", name: "applicant_form[partner]"
    choose "Unemployed", name: "applicant_form[employment_status]"
    choose "Yes", name: "applicant_form[passporting]"
    click_on "Save and continue"
    fill_in_forms_until(:assets)
    fill_in_assets_screen(values: { valuables: "800" })
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen(vehicle_finance: "5")
    fill_in_forms_until(:check_answers)
    click_on "Submit"
  end
end

RSpec.describe "passported check", type: :feature do
  context "with stubbing" do
    include_context "with passported attributes"
    let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

    before { travel_to fixed_arbitrary_date }

    it "sends the right data to CFE for certificated work" do
      stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)
        expect(parsed["assessment"]).to eq({
          "submission_date" => "2023-02-15",
          "level_of_help" => "certificated",
        })
        expect(parsed["proceeding_types"]).to be_present
        expect(parsed["applicant"]).to eq({
          "date_of_birth" => "1973-02-15",
          "has_partner_opponent" => false,
          "receives_qualifying_benefit" => true,
          "receives_asylum_support" => false,
          "employed" => false,
        })
        expect(parsed["vehicles"]).to eq([{
          "value" => 1.0,
          "loan_amount_outstanding" => 5.0,
          "date_of_purchase" => "2021-02-15",
          "in_regular_use" => false,
          "subject_matter_of_dispute" => false,
        }])
        expect(parsed["capitals"]).to eq({
          "bank_accounts" => [],
          "non_liquid_capital" => [{ "value" => 800.0, "description" => "Non Liquid Asset", "subject_matter_of_dispute" => false }],
        })
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )
      submit_data_to_cfe

      expect(stubbed_assessment_call).to have_been_requested
    end
  end

  context "when hitting the API", :end2end do
    context "with passported attributes" do
      include_context "with passported attributes"

      it "renders content" do
        submit_data_to_cfe
        expect(page).to have_content("Your client is likely to qualify for civil legal aid")
        expect(page).to have_content("Assessed property value")
        expect(page).to have_content("Total of home client lives in and any additional property\n£0.00")
        expect(page).to have_content("Total assessed disposable capital£801.00") # 800 non liquid and 1 from vehicle
        expect(page).not_to have_content("Income calculation")
        expect(page).not_to have_content("Outgoings calculation")
      end
    end
  end
end
