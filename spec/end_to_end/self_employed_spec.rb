require "rails_helper"

RSpec.describe "Self-employed flow", :self_employed_flag, type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  it "sends the right employment data to CFE" do
    stub = stub_request(:post, %r{assessments\z}).with { |request|
      parsed = JSON.parse(request.body)

      expect(parsed["employment_details"]).to eq(
        [
          {
            "income" => {
              "benefits_in_kind" => 0,
              "frequency" => "weekly",
              "gross" => 1.0,
              "national_insurance" => -0.0,
              "tax" => -0.0,
              "receiving_only_statutory_sick_or_maternity_pay" => false,
            },
          },
        ],
      )
    }.to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    stub_request(:get, %r{state_benefit_type\z}).to_return(
      body: [].to_json,
      headers: { "Content-Type" => "application/json" },
    )

    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    expect(stub).to have_been_requested
  end

  it "sends the right self-employment data to CFE" do
    stub = stub_request(:post, %r{assessments\z}).with { |request|
      parsed = JSON.parse(request.body)

      expect(parsed["self_employment_details"]).to eq(
        [
          {
            "income" => {
              "frequency" => "weekly",
              "gross" => 1.0,
              "national_insurance" => -0.0,
              "tax" => -0.0,
            },
          },
        ],
      )
    }.to_return(
      body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
      headers: { "Content-Type" => "application/json" },
    )

    stub_request(:get, %r{state_benefit_type\z}).to_return(
      body: [].to_json,
      headers: { "Content-Type" => "application/json" },
    )

    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen({ type: "Self-employment income" })
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    expect(stub).to have_been_requested
  end
end
