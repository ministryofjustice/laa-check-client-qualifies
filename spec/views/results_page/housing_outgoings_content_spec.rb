require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Housing outgoings section" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:session_data) do
      {
        partner: false,
        passporting: false,
        child_dependants: false,
        adult_dependants: false,
        property_owned: "shared_ownership",
        property_landlord: true,
        housing_payments: 600.0,
        housing_payments_frequency: "monthly",
        housing_benefit_relevant: false,
        api_response:,
      }.with_indifferent_access
    end
    let(:check) { Check.new(session_data) }
    let(:api_response) do
      FactoryBot.build(
        :api_result,
        eligible: "eligible",
        result_summary: {
          overall_result: {
            proceeding_types: [],
          },
          gross_income: {
            total_gross_income: 0.0,
            proceeding_types: [],
            combined_total_gross_income: 0.0,
          },
          disposable_income: {
            gross_housing_costs: 600.0,
            housing_costs: 600.0,
            housing_benefit: 0.0,
            net_housing_costs: 545.0,
            allowed_housing_costs: 545.0,
            maintenance_allowance: 0.0,
            total_outgoings_and_allowances: 545.0,
            total_disposable_income: -545.0,
            employment_income: {},
            proceeding_types: [
              {
                ccms_code: "SE003",
                upper_threshold: 733.0,
                lower_threshold: 733.0,
                result: "eligible",
                client_involvement_type: "A",
              },
            ],
            combined_total_disposable_income: -545.0,
            combined_total_outgoings_and_allowances: 545.0,
            partner_allowance: 0,
            lone_parent_allowance: 0,
            income_contribution: 0.0,
          },
          capital: {
            pensioner_disregard_applied: 0.0,
            total_liquid: 0.0,
            total_non_liquid: 0.0,
            total_vehicle: 0.0,
            total_property: 0.0,
            total_mortgage_allowance: 999_999_999_999.0,
            total_capital: 0.0,
            subject_matter_of_dispute_disregard: 0.0,
            assessed_capital: 0.0,
            total_capital_with_smod: 0.0,
            disputed_non_property_disregard: 0,
            proceeding_types: [],
            combined_disputed_capital: 0,
            combined_non_disputed_capital: 0.0,
            capital_contribution: 0.0,
            pensioner_capital_disregard: 0.0,
            combined_assessed_capital: 0.0,
          },
        },
        assessment: {
          id: "ccq-shared-housing-content",
          applicant: {
            date_of_birth: "1975-03-19",
            involvement_type: "applicant",
            employed: nil,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
          },
          gross_income: {
            employment_income: [],
            irregular_income: {},
            state_benefits: {},
            other_income: {},
          },
          disposable_income: {
            monthly_equivalents: {
              all_sources: {
                rent_or_mortgage: 600.0,
              },
              bank_transactions: {},
              cash_transactions: {},
            },
            childcare_allowance: 0.0,
            deductions: {},
          },
          capital: {
            capital_items: {
              liquid: [],
              non_liquid: [],
              vehicles: [],
              properties: {
                main_home: {
                  value: 1.0,
                  outstanding_mortgage: 0.0,
                  percentage_owned: 1.0,
                  main_home: true,
                  shared_with_housing_assoc: true,
                  transaction_allowance: 0.0,
                  allowable_outstanding_mortgage: 0.0,
                  net_value: 1.0,
                  net_equity: 0.01,
                  smod_allowance: 0,
                  main_home_equity_disregard: 0.01,
                  assessed_equity: 0.0,
                  subject_matter_of_dispute: false,
                },
                additional_properties: [],
              },
            },
          },
        },
      )
    end

    before do
      assign(:model, calculation_result)
      assign(:check, check)
      params[:assessment_code] = :code
      render template: "results/show"
    end

    it "displays housing cap when client is single and has no dependants", :shared_ownership do
      expect(page_text).to match(/Housing payments(.+)£545.00/)
      expect(page_text).to have_content("Rent and mortgage costs minus any Housing Benefits the household gets")
      expect(page_text).to have_content("Housing costs are capped at £545 for single clients without dependants")
    end

    context "when client has a partner and dependant", :shared_ownership do
      let(:session_data) do
        {
          partner: true,
          passporting: false,
          child_dependants: true,
          child_dependants_count: 1,
          dependants_get_income: false,
          adult_dependants: false,
          property_owned: "shared_ownership",
          property_landlord: true,
          housing_payments: 600.0,
          housing_payments_frequency: "monthly",
          housing_benefit_relevant: false,
          api_response:,
        }.with_indifferent_access
      end

      let(:api_response) do
        FactoryBot.build(
          :api_result,
          eligible: "eligible",
          result_summary: {
            overall_result: {
              proceeding_types: [],
            },
            gross_income: {
              total_gross_income: 0.0,
              proceeding_types: [],
              combined_total_gross_income: 0.0,
            },
            disposable_income: {
              dependant_allowance_under_16: 361.7,
              dependant_allowance_over_16: 0,
              dependant_allowance: 361.7,
              gross_housing_costs: 600.0,
              housing_costs: 600.0,
              housing_benefit: 0.0,
              net_housing_costs: 600.0,
              allowed_housing_costs: 600.0,
              maintenance_allowance: 0.0,
              total_outgoings_and_allowances: 1186.57,
              total_disposable_income: -1186.57,
              employment_income: {},
              proceeding_types: [
                {
                  ccms_code: "SE003",
                  upper_threshold: 733.0,
                  lower_threshold: 733.0,
                  result: "eligible",
                  client_involvement_type: "A",
                },
              ],
              combined_total_disposable_income: -1186.57,
              combined_total_outgoings_and_allowances: 1186.57,
              partner_allowance: 224.87,
              lone_parent_allowance: 0,
              income_contribution: 0.0,
            },
            capital: {
              pensioner_disregard_applied: 0.0,
              total_liquid: 0.0,
              total_non_liquid: 0.0,
              total_vehicle: 0.0,
              total_property: 0.0,
              total_mortgage_allowance: 999_999_999_999.0,
              total_capital: 0.0,
              subject_matter_of_dispute_disregard: 0.0,
              assessed_capital: 0.0,
              total_capital_with_smod: 0,
              disputed_non_property_disregard: 0,
              proceeding_types: [],
              combined_disputed_capital: 0,
              combined_non_disputed_capital: 0,
              capital_contribution: 0.0,
              pensioner_capital_disregard: 0.0,
              combined_assessed_capital: 0.0,
            },
            partner_capital: {
              pensioner_disregard_applied: 0.0,
              total_liquid: 0.0,
              total_non_liquid: 0.0,
              total_vehicle: 0.0,
              total_property: 0.0,
              total_mortgage_allowance: 999_999_999_999.0,
              total_capital: 0.0,
              subject_matter_of_dispute_disregard: 0.0,
              assessed_capital: 0.0,
              total_capital_with_smod: 0,
              disputed_non_property_disregard: 0,
            },
            partner_gross_income: {
              total_gross_income: 0.0,
            },
            partner_disposable_income: {
              dependant_allowance_under_16: 0,
              dependant_allowance_over_16: 0,
              dependant_allowance: 0,
              gross_housing_costs: 0.0,
              housing_costs: 0.0,
              housing_benefit: 0.0,
              net_housing_costs: 0.0,
              allowed_housing_costs: 0.0,
              maintenance_allowance: 0.0,
              total_outgoings_and_allowances: 0.0,
              total_disposable_income: 0.0,
              employment_income: {},
            },
          },
          assessment: {
            id: "ccq-shared-housing-content",
            applicant: {
              date_of_birth: "1975-03-19",
              involvement_type: "applicant",
              employed: nil,
              has_partner_opponent: false,
              receives_qualifying_benefit: false,
            },
            gross_income: {
              employment_income: [],
              irregular_income: {},
              state_benefits: {},
              other_income: {},
            },
            disposable_income: {
              monthly_equivalents: {},
              childcare_allowance: 0.0,
              deductions: {
                dependants_allowance: 361.7,
                disregarded_state_benefits: 0.0,
              },
            },
            capital: {
              capital_items: {
                liquid: [],
                non_liquid: [],
                vehicles: [],
                properties: {
                  main_home: {
                    value: 0.0,
                    outstanding_mortgage: 0.0,
                    percentage_owned: 1.0,
                    main_home: true,
                    shared_with_housing_assoc: true,
                    transaction_allowance: 0,
                    allowable_outstanding_mortgage: 0.0,
                    net_value: 1.0,
                    net_equity: 0.01,
                    smod_allowance: 0,
                    main_home_equity_disregard: 0.01,
                    assessed_equity: 0,
                    subject_matter_of_dispute: false,
                  },
                  additional_properties: [],
                },
              },
            },
            partner_gross_income: {
              employment_income: [],
              irregular_income: {},
              state_benefits: {},
              other_income: {},
            },
            partner_disposable_income: {
              monthly_equivalents: {},
              childcare_allowance: 0.0,
              deductions: {
                dependants_allowance: 0.0,
                disregarded_state_benefits: 0.0,
              },
            },
            partner_capital: {
              capital_items: {
                liquid: [],
                non_liquid: [],
                vehicles: [],
                properties: {
                  main_home: {
                    value: 0.0,
                    outstanding_mortgage: 0.0,
                    percentage_owned: 0.0,
                    main_home: true,
                    shared_with_housing_assoc: false,
                    transaction_allowance: 0,
                    allowable_outstanding_mortgage: 0.0,
                    net_value: 0,
                    net_equity: 0,
                    smod_allowance: 0,
                    main_home_equity_disregard: 0,
                    assessed_equity: 0,
                    subject_matter_of_dispute: false,
                  },
                  additional_properties: [],
                },
              },
            },
          },
        )
      end

      it "does not display housing cap" do
        expect(page_text).to match(/Housing payments(.+)£600.00/)
        expect(page_text).to have_content("Rent and mortgage costs minus any Housing Benefits the household gets")
        expect(page_text).not_to have_content("Housing costs are capped at £545 for single clients without dependants")
        expect(page_text).to have_content("An allowance of £361.70 applied for each dependant, minus any income they receive")
      end
    end
  end
end
