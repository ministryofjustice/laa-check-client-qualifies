FactoryBot.define do
  factory :api_result, class: Hash do
    initialize_with { attributes }

    success { true }
    result_summary { build(:result_summary) }
    assessment { build(:assessment) }

    transient do
      eligible { "ineligible" }
      main_home { nil }
      additional_property { nil }
      over_60 { false }
      partner { false }
      overall_result { nil }
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
        %i[capital gross_income disposable_income].each do |subsection|
          %i[assessment result_summary].each do |section|
            api_result.fetch(section)[:"partner_#{subsection}"] ||= api_result.dig(section, subsection).dup
          end
        end
      end

      if evaluator.overall_result
        api_result.fetch(:result_summary)[:overall_result].merge!(evaluator.overall_result)
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

  factory :proceeding_type, class: Hash do
    initialize_with { attributes }
    ccms_code { "SE013" }
    client_involvement_type { "I" }
    upper_threshold { 2657.0 }
    lower_threshold { 0.0 }
    result { "eligible" }
  end

  factory :result_summary, class: Hash do
    initialize_with { attributes }
    overall_result do
      { result: "ineligible" }
    end

    gross_income { build(:gross_income_summary) }
    disposable_income { build(:disposable_income_summary) }
    capital { build(:capital_summary) }
  end

  factory :gross_income_summary, class: Hash do
    initialize_with { attributes }
    proceeding_types { [build(:proceeding_type)] }
  end

  factory :disposable_income_summary, class: Hash do
    initialize_with { attributes }
    proceeding_types { [build(:proceeding_type)] }
  end

  factory :capital_summary, class: Hash do
    initialize_with { attributes }
    proceeding_types { [build(:proceeding_type)] }
    pensioner_capital_disregard { 0 }
    subject_matter_of_dispute_disregard { 0 }
    pensioner_disregard_applied { 123 }
    total_capital { 0 }
    total_capital_with_smod { 0 }
    disputed_non_property_disregard { 0 }
  end

  factory :assessment, class: Hash do
    initialize_with { attributes }
    capital do
      {
        capital_items: {
          properties: {
            additional_properties: [],
          },
          vehicles: [],
          liquid: [],
          non_liquid: [],
        },
      }
    end
  end
end
