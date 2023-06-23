require "rails_helper"

RSpec.describe "Certificated check without partner", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  it "sends the right data to CFE for certificated work" do
    stub = stub_request(:post, %r{assessments\z}).with { |request|
      parsed = JSON.parse(request.body)

      expect(parsed["assessment"]).to eq({
        "submission_date" => "2023-02-15",
        "level_of_help" => "certificated",
      })
      expect(parsed["proceeding_types"]).to eq([{ "ccms_code" => "SE003", "client_involvement_type" => "A" }])
      expect(parsed["applicant"]).to eq({
        "date_of_birth" => "1973-02-15",
        "employed" => true,
        "has_partner_opponent" => false,
        "receives_qualifying_benefit" => false,
        "receives_asylum_support" => false,
      })
      expect(parsed["dependants"]).to eq([
        { "date_of_birth" => "2012-02-15",
          "in_full_time_education" => true,
          "relationship" => "child_relative",
          "monthly_income" => 0,
          "assets_value" => 0 },
      ])

      expect(parsed.dig("employment_income", 0, "payments", 0)).to eq({
        "gross" => 1.0,
        "tax" => 0.0,
        "national_insurance" => 0.0,
        "client_id" => "id-0",
        "date" => "2023-02-15",
        "benefits_in_kind" => 0,
        "net_employment_income" => 1.0,
      })

      expect(parsed["irregular_incomes"]["payments"]).to eq(
        [{ "income_type" => "student_loan", "frequency" => "annual", "amount" => 100.0 }],
      )

      expect(parsed["regular_transactions"]).to eq(
        [
          { "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 },
          { "operation" => "debit", "category" => "rent_or_mortgage", "frequency" => "monthly", "amount" => 100.0 },
        ],
      )

      expect(parsed.dig("state_benefits", 0, "name")).to eq "A"
      expect(parsed.dig("state_benefits", 0, "payments", 0)).to eq({ "date" => "2023-02-15", "amount" => 1.0, "client_id" => "" })

      expect(parsed["vehicles"]).to eq([{
        "value" => 1.0,
        "loan_amount_outstanding" => 5.0,
        "date_of_purchase" => "2021-02-15",
        "in_regular_use" => false,
        "subject_matter_of_dispute" => false,
      }])
      expect(parsed["capitals"]).to eq({
        "bank_accounts" => [],
        "non_liquid_capital" => [{ "value" => 700.0, "description" => "Non Liquid Asset", "subject_matter_of_dispute" => false }],
      })

      expect(parsed["properties"]).to eq({
        "main_home" => {
          "outstanding_mortgage" => 1.0,
          "percentage_owned" => 1,
          "shared_with_housing_assoc" => false,
          "subject_matter_of_dispute" => false,
          "value" => 1.0,
        },
      })
    }.to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    stub_request(:get, %r{state_benefit_type\z}).to_return(
      body: [].to_json,
      headers: { "Content-Type" => "application/json" },
    )

    # This test explicitly asserts what screens are visited in what order
    start_assessment
    fill_in_provider_users_screen
    fill_in_level_of_help_screen
    fill_in_matter_type_screen
    fill_in_applicant_screen(employed: "Employed and in work")
    fill_in_dependant_details_screen(child_dependants: "Yes", child_dependants_count: 1)
    fill_in_employment_screen
    fill_in_benefits_screen(choice: "Yes")
    fill_in_benefit_details_screen
    fill_in_other_income_screen(values: { friends_or_family: "200", student_finance: "100" }, frequencies: { friends_or_family: "Every week" })
    fill_in_outgoings_screen
    fill_in_assets_screen(values: { valuables: "700" })
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen(vehicle_finance: "5")
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    fill_in_mortgage_or_loan_payment_screen(amount: "100")
    fill_in_additional_property_screen
    click_on "Submit"

    expect(stub).to have_been_requested
  end
end
