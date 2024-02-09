require "rails_helper"

RSpec.shared_context "with partner data" do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen
    fill_in_partner_employment_status_screen(choice: "Employed")
    fill_in_partner_income_screen(frequency: "Every week")
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
  end
end

RSpec.describe "Certificated check with partner", type: :feature do
  context "when the client has a partner" do
    let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

    before do
      travel_to fixed_arbitrary_date
      stub_request(:get, %r{state_benefit_type\z}).to_return(
        body: [].to_json,
        headers: { "Content-Type" => "application/json" },
      )
    end

    include_context "with partner data"

    it "sends the right data to CFE for certificated work", :stub_cfe_calls do
      WebMock.reset!

      stub = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)

        content = parsed["partner"]
        expect(content["partner"]).to eq({ "date_of_birth" => "1973-02-15", "employed" => true })
        expect(content["irregular_incomes"]).to eq([{ "income_type" => "unspecified_source", "frequency" => "quarterly", "amount" => 100.0 }])
        expect(content.dig("employment_details", 0, "income")).to eq({ "benefits_in_kind" => 0,
                                                                       "frequency" => "weekly",
                                                                       "gross" => 1.0,
                                                                       "national_insurance" => -0.0,
                                                                       "receiving_only_statutory_sick_or_maternity_pay" => false,
                                                                       "tax" => -0.0 })
        expect(content["regular_transactions"]).to eq(
          [
            { "operation" => "credit", "category" => "friends_or_family", "frequency" => "weekly", "amount" => 200.0 },
            { "operation" => "credit", "category" => "benefits", "frequency" => "weekly", "amount" => 1.0 },
          ],
        )
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

      click_on "Submit"

      expect(stub).to have_been_requested
    end
  end

  context "when interacting with the CFE API", :end2end do
    include_context "with partner data"

    it "shows appropriate information on the results page" do
      click_on "Submit"

      expect(page).to have_content "Partner's monthly income\nAll figures have been converted into a monthly amount.\nEmployment income\n£4.33"
      expect(page).to have_content "Benefits received\nThis does not include Housing Benefit\n£4.33"
      expect(page).to have_content "Financial help from friends and family\n£866.67"
      expect(page).to have_content "Other sources\n£33.33"
      expect(page).to have_content "Partner allowance\nA fixed allowance if your client has a partner\n£211.32"
      expect(page).to have_content "Employment expenses\nA fixed allowance if the partner gets a salary or wage\n£45.00"
      expect(page).to have_content "Partner other property 1\nValue\n£1.00Outstanding mortgage\n-£1.00Assessed value\nPartner’s 1% share of home equity\n£0.00"
      expect(page).to have_content "Investments and valuables\n£700.00"
    end
  end
end
