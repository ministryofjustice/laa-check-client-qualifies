FactoryBot.define do
  factory :api_result, class: Hash do
    initialize_with { attributes }

    success { true }
    result_summary do
      {
        overall_result: {
          result: "ineligible",
        },
        gross_income: {
          proceeding_types: [
            { "ccms_code": "DA001",
              "client_involvement_type": "A",
              "upper_threshold": 999_999_999_999.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
            { "ccms_code": "SE013",
              "client_involvement_type": "I",
              "upper_threshold": 2657.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
          ],
        },
        disposable_income: {
          proceeding_types: [
            { "ccms_code": "DA001",
              "client_involvement_type": "A",
              "upper_threshold": 999_999_999_999.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
            { "ccms_code": "SE013",
              "client_involvement_type": "I",
              "upper_threshold": 2657.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
          ],
        },
        capital: {
          pensioner_capital_disregard: 0,
          subject_matter_of_dispute_disregard: 0,
          proceeding_types: [
            { "ccms_code": "DA001",
              "client_involvement_type": "A",
              "upper_threshold": 999_999_999_999.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
            { "ccms_code": "SE013",
              "client_involvement_type": "I",
              "upper_threshold": 2657.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
          ],
        },
      }
    end
    assessment do
      {
        capital: {
          capital_items: {
            properties: {
              additional_properties: [],
            },
            vehicles: [],
            liquid: [],
            non_liquid: [],
          },
        },
      }
    end

    transient do
      eligible { false }
      main_home { nil }
    end

    after(:build) do |api_result, evaluator|
      if evaluator.main_home
        api_result.dig(:assessment, :capital, :capital_items, :properties)[:main_home] = evaluator.main_home
      end

      if evaluator.eligible
        api_result.fetch(:result_summary).merge! overall_result: { result: "eligible" }
      end
    end
  end

  factory :property_api_result, class: Hash do
    initialize_with { attributes }

    value { 200_000.0 }
    outstanding_mortgage { 90_000.0 }
    net_equity { 110_000.0 }
    assessed_equity { 100_000.0 }
    transaction_allowance { 0 }
  end
end
