FactoryBot.define do
  factory :api_result, class: Hash do
    initialize_with { attributes }

    success { true }
    result_summary { build(:result_summary) }
    assessment { build(:assessment) }

    transient do
      eligible { nil }
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

      if api_result.fetch(:result_summary)[:overall_result].nil?
        api_result.fetch(:result_summary)[:overall_result] = {}
      end

      if evaluator.eligible
        api_result.fetch(:result_summary)[:overall_result][:result] = evaluator.eligible
      end

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
    net_value { 110_000 }
  end

  factory :gross_income_api_result, class: Hash do
    initialize_with { attributes }

    other_income do
      {
        monthly_equivalents: {
          all_sources: {
            pension: 15,
            maintenance_in: 5,
            friends_or_family: 47.67,
            property_or_lodger: 6.5,
          },
        },
      }
    end

    state_benefits do
      {
        monthly_equivalents: {
          all_sources: 0,
          bank_transactions: [],
          cash_transactions: 0,
        },
      }
    end

    irregular_income do
      {
        monthly_equivalents: {
          student_loan: 108,
          unspecified_source: 50,
        },
      }
    end

    employment_income { [] }
  end

  factory :partner_gross_income_api_result, class: Hash do
    initialize_with { attributes }

    other_income do
      {
        monthly_equivalents: {
          all_sources: {
            pension: 25,
            maintenance_in: 20,
            friends_or_family: 15,
            property_or_lodger: 10,
          },
          bank_transactions: {
            pension: 0,
            maintenance_in: 0,
            friends_or_family: 0,
            property_or_lodger: 0,
          },
          cash_transactions: {
            pension: 0,
            maintenance_in: 0,
            friends_or_family: 0,
            property_or_lodger: 0,
          },
        },
      }
    end

    state_benefits do
      {
        monthly_equivalents: {
          all_sources: 0,
          bank_transactions: [],
          cash_transactions: 0,
        },
      }
    end

    irregular_income do
      {
        monthly_equivalents: {
          student_loan: 199,
          unspecified_source: 77,
        },
      }
    end

    employment_income { [] }
  end

  factory :proceeding_type, class: Hash do
    initialize_with { attributes }
    ccms_code { "SE003" }
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
    total_gross_income { 1000.0 }
    proceeding_types { [build(:proceeding_type)] }
  end

  factory :disposable_income_summary, class: Hash do
    initialize_with { attributes }
    proceeding_types { [build(:proceeding_type)] }

    factory :disposable_income_summary_when_single_and_no_dependants do
      gross_housing_costs { 600.0 }
      housing_costs { 600.0 }
      housing_benefit { 55.0 }
      net_housing_costs { 545.0 }
      allowed_housing_costs { 545.0 }
      total_outgoings_and_allowances { 545.0 }
      total_disposable_income { -545.0 }
      combined_total_outgoings_and_allowances { 545.0 }
      combined_total_disposable_income { -545.0 }
    end

    factory :disposable_income_summary_with_partner_and_dependants do
      dependant_allowance { 361.7 }
      dependant_allowance_under_16 { 361.7 }
      gross_housing_costs { 600.0 }
      housing_costs { 600.0 }
      housing_benefit { 0.0 }
      net_housing_costs { 600.0 }
      allowed_housing_costs { 600.0 }
      total_outgoings_and_allowances { 1186.57 }
      total_disposable_income { -1186.57 }
      combined_total_outgoings_and_allowances { 1186.57 }
      combined_total_disposable_income { -1186.57 }
      partner_allowance { 224.87 }
    end
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
          vehicles: [
            { value: 2000.0,
              loan_amount_outstanding: 0.0,
              date_of_purchase: "2019-03-08",
              in_regular_use: true,
              included_in_assessment: false,
              disregards_and_deductions: 2000.0,
              assessed_value: 0.0 },
            { value: 5432.0,
              loan_amount_outstanding: 2432.0,
              date_of_purchase: "2019-03-08",
              in_regular_use: false,
              included_in_assessment: false,
              disregards_and_deductions: 0.0,
              assessed_value: 3000.0 },
          ],
          liquid: [],
          non_liquid: [],
        },
      }
    end

    gross_income { FactoryBot.build(:gross_income_api_result) }
    partner_gross_income { FactoryBot.build(:partner_gross_income_api_result) }
  end
end
