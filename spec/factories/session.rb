FactoryBot.define do
  factory :basic_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }

    trait :with_main_home do
      property_owned { "outright" }
      house_value { 234_234 }
      mortgage { 123_123 }
      percentage_owned { 100 }
      house_in_dispute { false }
      joint_ownership { false }
    end

    trait :with_partner_owned_main_home do
      partner { true }
      property_owned { "none" }
      partner_property_owned { "with_mortgage" }
      partner_house_value { 234_234 }
      partner_mortgage { 123_123 }
      partner_percentage_owned { 100 }
    end

    trait :with_no_main_home do
      property_owned { "none" }
      partner_property_owned { "none" }
    end

    trait :with_vehicle do
      vehicle_owned { true }
      vehicle_value { "1000.0" }
      vehicle_pcp { false }
      vehicle_over_3_years_ago { false }
      vehicle_in_regular_use { false }
      vehicle_in_dispute { false }
    end

    trait :with_zero_capital_assets do
      property_value { 0 }
      savings { 0 }
      investments { 0 }
      valuables { 0 }
      in_dispute { %w[] }
    end
  end

  factory :full_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }

    level_of_help { "certificated" }
    proceeding_type { nil }
    legacy_proceeding_type { "SE003" }
    over_60 { false }
    employment_status { "receiving_statutory_pay" }
    partner { true }
    passporting { false }
    child_dependants { true }
    child_dependants_count { 2 }
    adult_dependants { true }
    adult_dependants_count { 1 }
    frequency { "two_weeks" }
    gross_income { 123 }
    income_tax { 1 }
    national_insurance { 1 }
    housing_benefit { true }
    housing_benefit_value { 234 }
    housing_benefit_frequency { "every_week" }
    benefits do
      [
        { "id" => "c7b72db5-2c4d-4f04-a7c8-4b5adae1bfa0",
          "benefit_type" => "aaa",
          "benefit_amount" => 345,
          "benefit_frequency" => "monthly" },
      ]
    end
    add_benefit { false }
    friends_or_family_value { 45 }
    friends_or_family_frequency { "every_week" }
    maintenance_value { 56 }
    maintenance_frequency { "every_two_weeks" }
    property_or_lodger_value { 67 }
    property_or_lodger_frequency { "every_four_weeks" }
    pension_value { 78 }
    pension_frequency { "monthly" }
    student_finance_value { 89 }
    other_value { 9 }
    housing_payments_value { 12 }
    housing_payments_frequency { "every_week" }
    childcare_payments_value { 23 }
    childcare_payments_frequency { "every_two_weeks" }
    maintenance_payments_value { 34 }
    maintenance_payments_frequency { "total" }
    legal_aid_payments_value { 46 }
    legal_aid_payments_frequency { "monthly" }
    property_owned { "with_mortgage" }
    house_value { 234_234 }
    mortgage { 123_123 }
    percentage_owned { 80 }
    house_in_dispute { false }
    joint_ownership { true }
    joint_percentage_owned { 11 }
    vehicle_owned { true }
    vehicle_value { 5556 }
    vehicle_pcp { true }
    vehicle_finance { 4445 }
    vehicle_over_3_years_ago { true }
    vehicle_in_regular_use { false }
    vehicle_in_dispute { true }
    property_value { 123 }
    property_mortgage { 1313 }
    property_percentage_owned { 44 }
    savings { 553 }
    investments { 345 }
    valuables { 665 }
    in_dispute { %w[savings investments valuables] }
    partner_over_60 { true }
    partner_employment_status { "in_work" }
    partner_child_dependants { true }
    partner_child_dependants_count { 2 }
    partner_adult_dependants { true }
    partner_adult_dependants_count { 5 }
    partner_frequency { "week" }
    partner_gross_income { 1414 }
    partner_income_tax { 44 }
    partner_national_insurance { 55 }
    partner_housing_benefit { true }
    partner_housing_benefit_value { 2424 }
    partner_housing_benefit_frequency { "every_week" }
    partner_benefits do
      [
        { "id" => "a7b72db5-2c4d-4f04-a7c8-4b5adae1bfa0",
          "benefit_type" => "bbb",
          "benefit_amount" => 678,
          "benefit_frequency" => "monthly" },
      ]
    end
    partner_add_benefit { false }
    partner_friends_or_family_value { 99 }
    partner_friends_or_family_frequency { "every_week" }
    partner_maintenance_value { 89 }
    partner_maintenance_frequency { "every_two_weeks" }
    partner_property_or_lodger_value { 668 }
    partner_property_or_lodger_frequency { "monthly" }
    partner_pension_value { 464 }
    partner_pension_frequency { "total" }
    partner_student_finance_value { 776 }
    partner_other_value { 335 }
    partner_housing_payments_value { 86 }
    partner_housing_payments_frequency { "every_four_weeks" }
    partner_childcare_payments_value { 14 }
    partner_childcare_payments_frequency { "every_two_weeks" }
    partner_maintenance_payments_value { 87 }
    partner_maintenance_payments_frequency { "monthly" }
    partner_legal_aid_payments_value { 117 }
    partner_legal_aid_payments_frequency { "every_week" }
    partner_vehicle_owned { true }
    partner_vehicle_value { 887 }
    partner_vehicle_pcp { true }
    partner_vehicle_finance { 355 }
    partner_vehicle_over_3_years_ago { false }
    partner_vehicle_in_regular_use { true }
    partner_property_value { 11_266 }
    partner_property_mortgage { 300 }
    partner_property_percentage_owned { 44 }
    partner_savings { 548 }
    partner_investments { 997 }
    partner_valuables { 234 }
  end
end
