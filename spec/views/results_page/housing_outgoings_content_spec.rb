require "rails_helper"

RSpec.describe "results/show.html.slim" do
  describe "Housing outgoings section" do
    let(:calculation_result) { CalculationResult.new(session_data) }
    let(:session_data) do
      {
        level_of_help: "controlled",
        client_age: "standard",
        property_owned: "shared_ownership",
        property_landlord: true,
        housing_payments: 600.0,
        housing_payments_frequency: "monthly",
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
            proceeding_types: [],
          },
          disposable_income: {
            gross_housing_costs: 600.0,
            housing_costs: 600.0,
            net_housing_costs: 545.0,
            allowed_housing_costs: 545.0,
            total_outgoings_and_allowances: 545.0,
            total_disposable_income: -545.0,
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
          },
          capital: {
            proceeding_types: [],
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
          disposable_income: {
            monthly_equivalents: {
              all_sources: {
                rent_or_mortgage: 600.0,
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

    it "displays housing cap when client is single and has no dependants" do
      expect(page_text).to match(/Housing payments(.+)£545.00/)
      expect(page_text).to have_content("Rent and mortgage costs minus any Housing Benefits your client gets")
      expect(page_text).to have_content("Housing costs are capped at £545 for single clients without dependants")
    end

    context "when client has a partner and dependant" do
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
              proceeding_types: [],
            },
            disposable_income: {
              dependant_allowance_under_16: 361.7,
              dependant_allowance: 361.7,
              gross_housing_costs: 600.0,
              housing_costs: 600.0,
              housing_benefit: 0.0,
              net_housing_costs: 600.0,
              allowed_housing_costs: 600.0,
              total_outgoings_and_allowances: 1186.57,
              total_disposable_income: -1186.57,
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
            },
            capital: {
              proceeding_types: [],
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
            disposable_income: {
              deductions: {
                dependants_allowance: 361.7,
              },
            },
            partner_capital: {
              capital_items: {},
            },
          },
        )
      end

      it "does not display housing cap" do
        expect(page_text).to match(/Housing payments(.+)£600.00/)
        expect(page_text).to have_content("Rent and mortgage costs minus any Housing Benefits the household gets")
        expect(page_text).not_to have_content("Rent and mortgage costs minus any Housing Benefits your client gets")
        expect(page_text).not_to have_content("Housing costs are capped at £545 for single clients without dependants")
        expect(page_text).to have_content("An allowance of £367.87 applied for each dependant, minus any income they receive")
      end
    end
  end
end
