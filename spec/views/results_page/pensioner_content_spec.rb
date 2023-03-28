require "rails_helper"

RSpec.describe "estimates/show.html.slim" do
  describe "Pensioner content" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:estimate) { EstimateModel.from_session(session_data) }

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
            dependant_allowance: 13.0,
            partner_allowance: 858.34,
            combined_total_outgoings_and_allowances: 5483.0,
            combined_total_disposable_income: 12_345.0,
          },
          capital: {
            pensioner_capital_disregard: 100_000,
            subject_matter_of_dispute_disregard: 0,
            pensioner_disregard_applied: 10_000,
            proceeding_types: [
              { "ccms_code": "SE013",
                "client_involvement_type": "I",
                "upper_threshold": 2657.0,
                "lower_threshold": 0.0,
                "result": "eligible" },
            ],
            total_capital: 0,
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

    let(:session_data) do
      {
        api_response:,
      }.with_indifferent_access
    end

    before do
      assign(:model, calculation_result)
      assign(:estimate, estimate)
      params[:id] = :id
      render template: "estimates/show"
    end

    context "when client has a partner and is over 60" do
      let(:api_response) { FactoryBot.build(:api_result, partner: true, over_60: true) }

      it "shows a separate pensioner disregard table" do
        expect(rendered).to include '<caption class="govuk-table__caption govuk-table__caption--m">Pensioner disregard'
      end
    end

    context "when client has no partner and is over 60" do
      let(:api_response) { FactoryBot.build(:api_result, partner: false, over_60: true) }

      it "shows pensioner disregard in the main capital table" do
        expect(rendered).to include '<th class="govuk-table__header">Pensioner disregard'
      end
    end
  end
end
