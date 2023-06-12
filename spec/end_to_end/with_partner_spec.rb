require "rails_helper"

RSpec.describe "Certificated check without partner", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  it "sends the right data to CFE for certificated work" do
    stub = stub_request(:post, %r{assessments\z}).with { |request|
      parsed = JSON.parse(request.body)

      content = parsed["partner"]
      expect(content["partner"]).to eq({ "date_of_birth" => "1973-02-15", "employed" => true })
      expect(content["irregular_incomes"]).to eq([{ "income_type" => "unspecified_source", "frequency" => "quarterly", "amount" => 100.0 }])
      expect(content.dig("employments", 0, "payments", 0)).to eq({ "gross" => 1.0,
                                                                   "tax" => 0.0,
                                                                   "national_insurance" => 0.0,
                                                                   "client_id" => "id-0",
                                                                   "date" => "2023-02-15",
                                                                   "benefits_in_kind" => 0,
                                                                   "net_employment_income" => 1.0 })
      expect(content["regular_transactions"]).to eq(
        [{ "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 }],
      )
      expect(content["state_benefits"].length).to eq 1
      expect(content["capitals"]).to eq({
        "bank_accounts" => [], "non_liquid_capital" => [{ "value" => 700.0, "description" => "Non Liquid Asset", "subject_matter_of_dispute" => false }]
      })
      expect(content["additional_properties"]).to eq([{
        "outstanding_mortgage" => 1.0,
        "percentage_owned" => 1,
        "shared_with_housing_assoc" => false,
        "value" => 1.0,
      }])
    }.to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    stub_request(:get, %r{state_benefit_type\z}).to_return(
      body: [].to_json,
      headers: { "Content-Type" => "application/json" },
    )

    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen(employed: "Employed and in work")
    fill_in_partner_employment_screen
    fill_in_partner_benefits_screen(choice: "Yes")
    fill_in_partner_benefit_details_screen
    fill_in_partner_other_income_screen(values: { friends_or_family: "200", other: "100" }, frequencies: { friends_or_family: "Every week" })
    fill_in_outgoings_screen
    fill_in_partner_outgoings_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen(values: { valuables: "700" })
    fill_in_vehicle_screen
    fill_in_property_screen
    fill_in_housing_costs_screen
    fill_in_additional_property_screen
    fill_in_partner_additional_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_partner_additional_property_details_screen
    click_on "Submit"

    expect(stub).to have_been_requested
  end
end
