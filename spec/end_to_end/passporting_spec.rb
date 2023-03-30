require "rails_helper"

RSpec.describe "Certificated passported check", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  it "sends the right data to CFE for certificated work" do
    stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with do |request|
      expect(request.body).to eq({ submission_date: "2023-02-15", level_of_help: "certificated" }.to_json)
    end
    create_assessment_stub = stubbed_assessment_call.to_return(
      body: { assessment_id: "assessment_id" }.to_json,
      headers: { "Content-Type" => "application/json" },
    )
    create_proceeding_types_stub = stub_request(:post, %r{proceeding_types\z})

    create_applicant_stub = stub_request(:post, %r{applicant\z}).with do |request|
      expected_payload = {
        applicant: {
          date_of_birth: "1973-02-15",
          has_partner_opponent: false,
          receives_qualifying_benefit: true,
          employed: false,
        },
      }
      expect(request.body).to eq(expected_payload.to_json)
    end

    create_vehicles_stub = stub_request(:post, %r{vehicles\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content).to eq({
        "vehicles" => [
          {
            "value" => "1.0",
            "loan_amount_outstanding" => "5.0",
            "date_of_purchase" => "2021-02-15",
            "in_regular_use" => false,
            "subject_matter_of_dispute" => false,
          },
        ],
      })
    end

    create_capitals_stub = stub_request(:post, %r{capitals\z}).with do |request|
      expected_payload = {
        "bank_accounts": [],
        "non_liquid_capital": [{ "value": "800.0", "description": "Non Liquid Asset", "subject_matter_of_dispute": false }],
      }
      request.body == expected_payload.to_json
    end

    get_assessment_stub = stub_request(:get, %r{assessments/assessment_id\z}).to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen(vehicle_finance: "5")
    fill_in_assets_screen(values: { valuables: "800" })
    click_on "Submit"

    stubs = [create_assessment_stub,
             create_proceeding_types_stub,
             create_applicant_stub,
             create_vehicles_stub,
             create_capitals_stub,
             get_assessment_stub]

    expect(stubs).to all(have_been_requested)
  end
end
