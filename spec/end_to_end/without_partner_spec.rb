require "rails_helper"

RSpec.shared_context "with a no-partner, non-passported certificated check" do
  before do
    # This test explicitly asserts what screens are visited in what order
    start_assessment
    fill_in_level_of_help_screen
    fill_in_domestic_abuse_applicant_screen
    fill_in_immigration_or_asylum_type_upper_tribunal_screen
    fill_in_applicant_screen
    fill_in_dependant_details_screen(child_dependants: "Yes", child_dependants_count: 1)
    fill_in_dependant_income_screen(choice: "Yes")
    fill_in_dependant_income_details_screen
    fill_in_employment_status_screen(choice: "Employed")
    fill_in_income_screen
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
  end
end

RSpec.describe "Certificated check without partner", type: :feature do
  context "when stubbing the CFE API" do
    let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

    before do
      travel_to fixed_arbitrary_date
      stub_request(:get, %r{state_benefit_type\z}).to_return(
        body: [].to_json,
        headers: { "Content-Type" => "application/json" },
      )
    end

    include_context "with a no-partner, non-passported certificated check"

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
          "receives_qualifying_benefit" => false,
        })
        expect(parsed["dependants"]).to eq([
          { "date_of_birth" => "2006-02-15",
            "in_full_time_education" => true,
            "relationship" => "child_relative",
            "income" => {
              "amount" => 1.0,
              "frequency" => "weekly",
            },
            "assets_value" => 0 },
        ])

        expect(parsed.dig("employment_details", 0, "income")).to eq({ "benefits_in_kind" => 0,
                                                                      "frequency" => "weekly",
                                                                      "gross" => 1.0,
                                                                      "national_insurance" => -0.0,
                                                                      "receiving_only_statutory_sick_or_maternity_pay" => false,
                                                                      "tax" => -0.0 })

        expect(parsed["irregular_incomes"]["payments"]).to eq(
          [{ "income_type" => "student_loan", "frequency" => "annual", "amount" => 100.0 }],
        )

        expect(parsed["regular_transactions"]).to eq(
          [
            { "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 },
            { "operation" => "debit", "category" => "rent_or_mortgage", "frequency" => "monthly", "amount" => 100.0 },
            { "operation" => "credit", "category" => "benefits", "frequency" => "weekly", "amount" => 1.0 },
          ],
        )

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

      click_on "Submit"

      expect(stub).to have_been_requested
    end
  end

  context "when interacting with the CFE API", :end2end do
    include_context "with a no-partner, non-passported certificated check"

    it "shows appropriate content on the results screen" do
      click_on "Submit"

      ["Your client is likely to qualify for civil legal aid",
       "We estimate they will have to pay towards the costs of their case:\n£32.58 per month from their disposable income - these contributions will continue for the duration of the case, however long it lasts£0.00 lump sum payment from their disposable capital - any capital contribution will not exceed the likely costs of their case and they might pay less than this amount",
       "Employment income\n£4.33",
       "Benefits received\nThis does not include Housing Benefit\n£4.33",
       "Financial help from friends and family\n£866.67",
       "Student finance\n£8.33",
       "Total monthly income£883.66",
       "Employment expenses\nA fixed allowance if your client gets a salary or wage\n£45.00",
       "Housing costs minus any Housing Benefit payments your client gets\n£100.00",
       "Dependants allowance\nAn allowance of £338.90 applied for each dependant, minus any income they receive\n£334.57",
       "Total monthly outgoings£479.57",
       "Assessed disposable monthly income\nTotal monthly income minus total monthly outgoings\n£404.09",
       "Home client lives in\nHome worth\n£1.00Outstanding mortgage\n-£1.001% share of home equity£0.00Assessed value£0.00",
       "Vehicle 1\nValue£1.00Assessed value£1.00",
       "Investments and valuables\n£700.00Total capital\n£701.00",
       "Total assessed disposable capital£701.00"].each do |line|
        expect(page).to have_content line
      end

      expect(page).not_to have_content "Partner"
    end
  end
end
