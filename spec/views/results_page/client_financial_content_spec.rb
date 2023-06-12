require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Client financial content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:session_data) { { api_response: }.with_indifferent_access }
    let(:dependant_allowance) { 13.0 }
    let(:check) { Check.new(session_data) }
    let(:vehicle_in_regular_use) { true }
    let(:api_response) do
      FactoryBot.build(
        :api_result,
        eligible: "eligible",
        result_summary: {
          overall_result: {},
          gross_income: {
            proceeding_types: [
              { upper_threshold: 2657.0,
                result: "eligible" },
            ],
            combined_total_gross_income: 40_000.0,
          },
          disposable_income: {
            proceeding_types: [
              { upper_threshold: 2657.0,
                result: "eligible" },
            ],
            employment_income: {
              gross_income: 1_000.0,
              tax: -5.0,
              national_insurance: -10.0,
              fixed_employment_deduction: -3.34,
            },
            net_housing_costs: 500.0,
            dependant_allowance:,
            partner_allowance: 858.34,
            combined_total_outgoings_and_allowances: 5483.0,
            combined_total_disposable_income: 12_345.0,
          },
          capital: {
            pensioner_disregard_applied: 3_000,
            pensioner_capital_disregard: 100_000,
            disputed_non_property_disregard: 1_000,
            subject_matter_of_dispute_disregard: 2_000,
            total_capital: 12_000,
            total_property: 0.0,
            total_vehicle: 3_000,
            total_liquid: 3676,
            total_non_liquid: 5353,
            proceeding_types: [
              { upper_threshold: 2657.0,
                result: "eligible" },
            ],
          },
        },
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
                  main_home_equity_disregard: 0,
                  percentage_owned: 100,
                },
                additional_properties: [
                  {
                    value: 51,
                    outstanding_mortgage: 52,
                    net_equity: 530,
                    assessed_equity: 52,
                    transaction_allowance: 534,
                    smod_allowance: 0,
                    main_home_equity_disregard: 0,
                    percentage_owned: 100,
                  },
                ],
              },
              vehicles: [
                {
                  value: 587,
                  loan_amount_outstanding: 234,
                  disregards_and_deductions: 144,
                  assessed_value: 3,
                  in_regular_use: vehicle_in_regular_use,
                },
                {
                  value: 3333,
                  loan_amount_outstanding: 1111,
                  disregards_and_deductions: 2222,
                  assessed_value: 3,
                  in_regular_use: vehicle_in_regular_use,
                },
              ],
              liquid: [],
              non_liquid: [],
            },
          },
          gross_income: {
            state_benefits: {
              monthly_equivalents: {
                all_sources: 56.00,
              },
            },
            other_income: {
              monthly_equivalents: {
                all_sources: {
                  friends_or_family: 100.0,
                  maintenance_in: 200.0,
                  property_or_lodger: 300.0,
                  pension: 400.0,
                },
              },
            },
            irregular_income: {
              monthly_equivalents: {
                student_loan: 50.0,
                unspecified_source: 111.0,
              },
            },
          },
          disposable_income: {
            monthly_equivalents: {
              all_sources: {
                child_care: 848.0,
                maintenance_out: 498.0,
                legal_aid: 41.79,
              },
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

    it "shows income content" do
      expect(page_text).to include "Employment income£1,000.00"
      expect(page_text).to include "Benefits receivedThis does not include Housing Benefit£56.00"
      expect(page_text).to include "Financial help from friends and family£100.00"
      expect(page_text).to include "Maintenance payments from a former partner£200.00"
      expect(page_text).to include "Income from a property or lodger£300.00"
      expect(page_text).to include "Pension£400.00"
      expect(page_text).to include "Student finance£50.00"
      expect(page_text).to include "Other sources£111.00"
      expect(page_text).to include "Total monthly income£40,000.00"
      expect(page_text).to include "Monthly income upper limit£2,657.00"
    end

    it "shows outgoings content" do
      expect(page_text).to match(/Housing payments(.+)£500.00/)
      expect(page_text).to match(/Childcare payments(.+)£848.00/)
      expect(page_text).to include "Maintenance payments to a former partner£498.00"
      expect(page_text).to include "Payments towards legal aid in a criminal case£41.79"
      expect(page_text).to include "Income tax£5.00"
      expect(page_text).to include "National Insurance£10.00"
      expect(page_text).to include "Employment expensesA fixed allowance if your client is employed£3.34"
      expect(page_text).to include "Dependants allowanceA fixed allowance deducted for each dependant in the household£13.00"
      expect(page_text).to include "Partner allowanceA fixed allowance if your client has a partner£858.34"
      expect(page_text).to include "Total monthly outgoings£5,483"
      expect(page_text).to include "Assessed disposable monthly incomeTotal monthly income minus total monthly outgoings£12,345.00"
      expect(page_text).to include "Disposable monthly income upper limit£2,657.00"
    end

    it "shows capital content" do
      expect(page_text).to include "Home client lives inHome worth£1.00"
      expect(page_text).to include "Outstanding mortgage-£2.00"
      expect(page_text).to include "Deductions3% of property value deducted for cost of sale-£34.00"
      expect(page_text).to include "Disputed asset disregard-£5.00"
      expect(page_text).to include "Assessed value£2.00"
      expect(page_text).to include "Client's additional propertyValue£51.00"
      expect(page_text).to include "Outstanding mortgage-£52.00"
      expect(page_text).to include "Deductions3% of property value deducted for cost of sale-£534.00"
      expect(page_text).to include "Assessed value£52.00"
      expect(page_text).to include "Vehicle 1Value£587.00"
      expect(page_text).to include "Outstanding payments£234.00"
      expect(page_text).to include "Disregards and deductions£144.00"
      expect(page_text).to include "Assessed value£6.00"
      expect(page_text).to include "Client's disposable capital"
      expect(page_text).to include "Assessed property valueTotal of home client lives in and any additional property£0.00"
      expect(page_text).to include "Assessed vehicle value£3,000.00"
      expect(page_text).to include "Money in bank accounts£3,676.00Investments and valuables£5,353.00"
      expect(page_text).to include "Total capital£12,000.00"
      expect(page_text).to include "Pensioner disregardApplied to remaining capital after disputed asset disregard has been applied, and up to a maximum of £100,000-£3,000.00"
      expect(page_text).to include "Disputed asset disregardEqual to the assessed value of all assets marked as disputed and capped at £100,000-£1,000.00"
      expect(page_text).to include "TotalTotal assessed disposable capital£0.00"
      expect(page_text).to include "Disposable capital upper limit£2,657.00"
    end

    context "when the vehicle is not in regular use" do
      let(:vehicle_in_regular_use) { false }

      it "does not show additional vehicle rows" do
        expect(page_text).not_to include "Outstanding payments -£234.00"
        expect(page_text).not_to include "Disregards and deductions -£144.00"
      end
    end

    context "when dependants allowance is not positive figure" do
      let(:dependant_allowance) { 0 }

      it "does not display the dependants allowance field" do
        expect(page_text).not_to include "Dependants allowance"
      end
    end

    context "when dependants allowance is nil" do
      let(:dependant_allowance) { nil }

      it "does not display the dependants allowance field" do
        expect(page_text).not_to include "Dependants allowance"
      end
    end

    context "when the vehicle is in regular use" do
      let(:vehicle_in_regular_use) { true }

      it "shows relevant additional vehicle rows" do
        expect(page_text).to include "Vehicle 1"
        expect(page_text).to include "Value£587.00"
        expect(page_text).to include "Outstanding payments£234.00"
        expect(page_text).to include "Disregards and deductions£144.00"
        expect(page_text).to include "Vehicle 2"
        expect(page_text).to include "Value£3,333.00"
        expect(page_text).to include "Assessed value£6.00"
        expect(page_text).to include "Outstanding payments£1,111.00"
        expect(page_text).to include "Disregards and deductions£2,222.00"
      end
    end
  end
end
