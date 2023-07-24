require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Partially owned property content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:check) { Check.new({}) }
    let(:session_data) { { api_response: }.with_indifferent_access }
    let(:api_response) do
      FactoryBot.build(
        :api_result,
        eligible: "eligible",
        assessment: {
          capital: {
            capital_items: {
              properties: {
                main_home: {
                  value: 1,
                  outstanding_mortgage: 2,
                  net_equity: 30,
                  assessed_equity: 2,
                  transaction_allowance: 34,
                  smod_allowance: 5,
                  main_home_equity_disregard: 3,
                  percentage_owned: 50,
                },
                additional_properties: [{
                  value: 1,
                  outstanding_mortgage: 3,
                  net_equity: 30,
                  assessed_equity: 2,
                  transaction_allowance: 35,
                  smod_allowance: 0,
                  main_home_equity_disregard: 0,
                  percentage_owned: 50,
                }],
              },
              vehicles: [],
              liquid: [],
              non_liquid: [],
            },
          },
        },
      )
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:id] = :id
      render template: "estimates/show"
    end

    it "shows partially owned main property content" do
      expect(page_text).to include "Home client lives inHome worth£1.00"
      expect(page_text).to include "Outstanding mortgage-£2.00"
      expect(page_text).to include "Deductions3% of property value deducted for cost of sale-£34.00"
      expect(page_text).to include "50% share of home equity£30.00"
      expect(page_text).to include "Disputed asset disregard-£5.00"
      expect(page_text).to include "Other disregardsApplied to the home equity and capped at £100,000-£3.00"
      expect(page_text).to include "Assessed value£2.00"
    end

    it "shows partially owned additional property content" do
      expect(page_text).to include "Client other property 1Value£1.00"
      expect(page_text).to include "Outstanding mortgage-£3.00"
      expect(page_text).to include "Deductions3% of property value deducted for cost of sale-£35.00"
      expect(page_text).to include "Assessed valueClient’s 50% share of home equity£2.00"
    end
  end
end
