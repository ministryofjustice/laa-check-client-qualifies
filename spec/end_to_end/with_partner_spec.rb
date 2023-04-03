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

    create_properties_stub = stub_request(:post, %r{properties\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content).to eq({
        "properties" => {
          "main_home" => {
            "outstanding_mortgage" => 1.0,
            "percentage_owned" => 1,
            "shared_with_housing_assoc" => false,
            "subject_matter_of_dispute" => false,
            "value" => "1.0",
          },
        },
      })
    end

    create_partner_stub = stub_request(:post, %r{partner_financials\z}).with do |request|
      content = JSON.parse(request.body)
      expect(content["partner"]).to eq({ "date_of_birth" => "1973-02-15", "employed" => true })
      expect(content["irregular_incomes"]).to eq([{ "income_type" => "unspecified_source", "frequency" => "quarterly", "amount" => "100.0" }])
      expect(content.dig("employments", 0, "payments", 0)).to eq({ "gross" => "1.0",
                                                                   "tax" => "-0.0",
                                                                   "national_insurance" => "-0.0",
                                                                   "client_id" => "id-0",
                                                                   "date" => "2023-02-15",
                                                                   "benefits_in_kind" => 0,
                                                                   "net_employment_income" => "1.0" })
      expect(content["regular_transactions"]).to eq(
        [{ "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => "200.0" }],
      )
      expect(content["state_benefits"].length).to eq 2
      expect(content["capitals"]).to eq({
        "bank_accounts" => [], "non_liquid_capital" => [{ "value" => "700.0", "description" => "Non Liquid Asset", "subject_matter_of_dispute" => false }]
      })
      expect(content["vehicles"]).to eq(
        [{ "value" => "1.0", "loan_amount_outstanding" => 0, "date_of_purchase" => "2021-02-15", "in_regular_use" => false, "subject_matter_of_dispute" => false }],
      )
      expect(content["dependants"]).to eq(
        [{ "date_of_birth" => "2012-02-15", "in_full_time_education" => true, "relationship" => "child_relative", "monthly_income" => 0, "assets_value" => 0 }],
      )
    end

    get_assessment_stub = stub_request(:get, %r{assessments/assessment_id\z}).to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen(employed: "Employed and in work")
    fill_in_partner_dependant_details_screen(child_dependants: "Yes", child_dependants_count: 1)
    fill_in_partner_employment_screen
    fill_in_partner_housing_benefit_screen(choice: "Yes")
    fill_in_partner_housing_benefit_details_screen
    fill_in_partner_benefits_screen(choice: "Yes")
    fill_in_add_partner_benefit_screen
    fill_in_partner_benefits_screen
    fill_in_partner_other_income_screen(values: { friends_or_family: "200", other: "100" }, frequencies: { friends_or_family: "Every week" })
    fill_in_partner_outgoings_screen
    fill_in_partner_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_partner_property_entry_screen
    fill_in_partner_vehicle_screen(choice: "Yes")
    fill_in_partner_vehicle_details_screen
    fill_in_partner_assets_screen(values: { valuables: "700" })
    click_on "Submit"

    stubs = [benefits_list_stub,
             create_assessment_stub,
             create_proceeding_types_stub,
             create_applicant_stub,
             create_properties_stub,
             create_partner_stub,
             get_assessment_stub]

    expect(stubs).to all(have_been_requested)
  end
end
