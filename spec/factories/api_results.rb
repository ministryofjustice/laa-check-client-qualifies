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
            { "ccms_code": "SE013",
              "client_involvement_type": "I",
              "upper_threshold": 2657.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
          ],
        },
        disposable_income: {
          proceeding_types: [
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
          pensioner_disregard_applied: 123,
          proceeding_types: [
            { "ccms_code": "SE013",
              "client_involvement_type": "I",
              "upper_threshold": 2657.0,
              "lower_threshold": 0.0,
              "result": "eligible" },
          ],
          total_capital: 0,
          disputed_non_property_disregard: 0,
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
      eligible { "ineligible" }
      main_home { nil }
      additional_property { nil }
      over_60 { false }
      partner { false }
    end

    after(:build) do |api_result, evaluator|
      if evaluator.main_home
        api_result.dig(:assessment, :capital, :capital_items, :properties)[:main_home] = evaluator.main_home
      end

      if evaluator.additional_property
        api_result.dig(:assessment, :capital, :capital_items, :properties)[:additional_properties] = [evaluator.additional_property]
      end

      api_result.fetch(:result_summary)[:overall_result] = { result: evaluator.eligible }

      if evaluator.over_60
        api_result.dig(:result_summary, :capital)[:pensioner_capital_disregard] = 100_000
      end

      if evaluator.partner
        api_result.fetch(:result_summary).merge!(
          {
            partner_capital: api_result.dig(:result_summary, :capital),
            partner_gross_income: api_result.dig(:result_summary, :gross_income),
            partner_disposable_income: api_result.dig(:result_summary, :disposable_income),
          },
        )
        api_result.fetch(:assessment).merge!(
          {
            partner_capital: api_result.dig(:assessment, :capital),
            partner_gross_income: api_result.dig(:assessment, :gross_income),
            partner_disposable_income: api_result.dig(:assessment, :disposable_income),
          },
        )
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
    smod_allowance { 0 }
    main_home_equity_disregard { 0 }
    percentage_owned { 100.0 }
  end
end
