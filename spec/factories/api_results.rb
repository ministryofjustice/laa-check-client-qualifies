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
    end

    after(:build) do |api_result, evaluator|
      if evaluator.eligible
        api_result.fetch(:result_summary).merge! overall_result: { result: "eligible" }
      end
    end
  end
end
