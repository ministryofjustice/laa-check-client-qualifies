require "rails_helper"

RSpec.describe "Certificated check without partner", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  it "sends the right data to CFE for certificated work" do
    benefits_list_stub = stub_request(:get, %r{state_benefit_type\z}).to_return(
      body: [].to_json,
      headers: { "Content-Type" => "application/json" },
    )
    stubbed_assessment_call = stub_request(:post, %r{assessments\z}).with do |request|
      expect(request.body).to eq({ submission_date: "2023-02-15", level_of_help: "certificated" }.to_json)
    end
    create_assessment_stub = stubbed_assessment_call.to_return(
      body: { assessment_id: "assessment_id" }.to_json,
      headers: { "Content-Type" => "application/json" },
    )
    create_proceeding_types_stub = stub_request(:post, %r{proceeding_types\z})
    create_applicant_stub = stub_request(:post, %r{applicant\z})
    create_dependants_stub = stub_request(:post, %r{dependants\z}).with do |request|
      expected_payload = { dependants: [
        { date_of_birth: "2012-02-15",
          in_full_time_education: true,
          relationship: "child_relative",
          monthly_income: 0,
          assets_value: 0 },
      ] }
      expect(request.body).to eq(expected_payload.to_json)
    end

    create_employments_stub = stub_request(:post, %r{employments\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content.dig("employment_income", 0, "payments", 0)).to eq({
        "gross" => "1.0",
        "tax" => "-0.0",
        "national_insurance" => "-0.0",
        "client_id" => "id-0",
        "date" => "2023-02-15",
        "benefits_in_kind" => 0,
        "net_employment_income" => "1.0",
      })
    end

    create_irregular_transactions_stub = stub_request(:post, %r{irregular_incomes\z}).with do |request|
      expected_payload = {
        payments: [
          { income_type: "student_loan", frequency: "annual", amount: "100.0" },
        ],
      }
      request.body == expected_payload.to_json
    end

    create_regular_transactions_stub = stub_request(:post, %r{regular_transactions\z}).with do |request|
      expected_payload = {
        "regular_transactions": [
          { "operation": "credit", "category": "friends_or_family", "frequency": "weekly", "amount": "200.0" },
        ],
      }
      request.body == expected_payload.to_json
    end

    create_benefits_stub = stub_request(:post, %r{state_benefits\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content.dig("state_benefits", 0, "name")).to eq "A"
      expect(content.dig("state_benefits", 0, "payments", 0)).to eq({ "date" => "2023-02-15", "amount" => "1.0", "client_id" => "" })
      expect(content.dig("state_benefits", 1, "name")).to eq "housing_benefit"
      expect(content.dig("state_benefits", 1, "payments", 0)).to eq({ "date" => "2023-02-15", "amount" => "1.0", "client_id" => "" })
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

    create_properties_stub = stub_request(:post, %r{properties\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content).to eq({
        "properties" => {
          "main_home" => {
            "outstanding_mortgage" => "1.0",
            "percentage_owned" => 1,
            "shared_with_housing_assoc" => false,
            "subject_matter_of_dispute" => false,
            "value" => "1.0",
          },
        },
      })
    end

    create_capitals_stub = stub_request(:post, %r{capitals\z}).with do |request|
      expected_payload = {
        "bank_accounts": [],
        "non_liquid_capital": [{ "value": "700.0", "description": "Non Liquid Asset", "subject_matter_of_dispute": false }],
      }
      request.body == expected_payload.to_json
    end

    get_assessment_stub = stub_request(:get, %r{assessments/assessment_id\z}).to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    # This test explicitly asserts what screens are visited in what order
    start_assessment
    fill_in_provider_users_screen
    fill_in_level_of_help_screen
    fill_in_applicant_screen(employed: "Employed and in work")
    fill_in_dependant_details_screen(child_dependants: "Yes", child_dependants_count: 1)
    fill_in_employment_screen
    fill_in_housing_benefit_screen(choice: "Yes")
    fill_in_housing_benefit_details_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    fill_in_benefits_screen
    fill_in_other_income_screen(values: { friends_or_family: "200", student_finance: "100" }, frequencies: { friends_or_family: "Every week" })
    fill_in_outgoings_screen
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen(vehicle_finance: "5")
    fill_in_assets_screen(values: { valuables: "700" })
    click_on "Submit"

    stubs = [benefits_list_stub,
             create_assessment_stub,
             create_proceeding_types_stub,
             create_applicant_stub,
             create_dependants_stub,
             create_employments_stub,
             create_benefits_stub,
             create_vehicles_stub,
             create_properties_stub,
             create_capitals_stub,
             create_regular_transactions_stub,
             create_irregular_transactions_stub,
             get_assessment_stub]

    expect(stubs).to all(have_been_requested)
  end
end
