FactoryBot.define do
  factory :minimal_complete_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }

    level_of_help { "certificated" }
    over_60 { false }
    employment_status { "unemployed" }
    partner { false }
    passporting { false }
    child_dependants { false }
    child_dependants_count { nil }
    adult_dependants { false }
    adult_dependants_count { nil }
    housing_benefit { false }
    add_benefit { false }
    friends_or_family_value { 0 }
    friends_or_family_frequency { "" }
    maintenance_value { 0 }
    maintenance_frequency { "" }
    property_or_lodger_value { 0 }
    property_or_lodger_frequency { "" }
    pension_value { 0 }
    pension_frequency { "" }
    student_finance_value { 0 }
    other_value { 0 }
    housing_payments_value { 0 }
    housing_payments_frequency { "" }
    childcare_payments_value { 0 }
    childcare_payments_frequency { "" }
    maintenance_payments_value { 0 }
    maintenance_payments_frequency { "" }
    legal_aid_payments_value { 0 }
    legal_aid_payments_frequency { "" }
    property_owned { "none" }
    vehicle_owned { false }
    property_value { 0 }
    property_mortgage { 0 }
    property_percentage_owned { nil }
    savings { 0 }
    investments { 0 }
    valuables { 0 }
    in_dispute { [] }

    trait :with_asylum_support do
      matter_type { "immigration" }
      asylum_support { true }
    end

    trait :with_main_home_in_dispute do
      property_owned { "outright" }
      house_value { 213_213 }
      mortgage { 111_222 }
      percentage_owned { 100 }
      house_in_dispute { true }
    end

    trait :with_main_home do
      property_owned { "outright" }
      house_value { 234_234 }
      mortgage { 123_123 }
      percentage_owned { 100 }
      house_in_dispute { false }
    end

    trait :with_employment do
      employment_status { "in_work" }
      frequency { "monthly" }
      gross_income { 1543 }
      income_tax { 223 }
      national_insurance { 112 }
    end

    trait :with_other_income do
      friends_or_family_value { 40 }
      friends_or_family_frequency { "every_week" }
      maintenance_value { 125 }
      maintenance_frequency { "every_two_weeks" }
      property_or_lodger_value { 155 }
      property_or_lodger_frequency { "every_four_weeks" }
      pension_value { 1234 }
      pension_frequency { "monthly" }
      student_finance_value { 359 }
      other_value { 259 }
    end

    trait :with_outgoings do
      housing_payments_value { 555 }
      housing_payments_frequency { "monthly" }
      childcare_payments_value { 333 }
      childcare_payments_frequency { "every_four_weeks" }
      maintenance_payments_value { 222 }
      maintenance_payments_frequency { "every_two_weeks" }
      legal_aid_payments_value { 56 }
      legal_aid_payments_frequency { "every_week" }
    end

    trait :with_partner do
      partner { true }
    end

    trait :with_no_main_home do
      property_owned { "none" }
    end

    trait :with_vehicle do
      vehicle_owned { true }
      vehicles do
        [{ "vehicle_value" => 1.0, "vehicle_pcp" => false, "vehicle_finance" => nil, "vehicle_over_3_years_ago" => false, "vehicle_in_regular_use" => false, "vehicle_in_dispute" => nil }]
      end
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
    matter_type { "other" }
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
    vehicle_owned { true }
    vehicles do
      [{ "vehicle_value" => 1.0, "vehicle_pcp" => false, "vehicle_finance" => nil, "vehicle_over_3_years_ago" => false, "vehicle_in_regular_use" => false, "vehicle_in_dispute" => nil }]
    end
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
    partner_childcare_payments_value { 14 }
    partner_childcare_payments_frequency { "every_two_weeks" }
    partner_maintenance_payments_value { 87 }
    partner_maintenance_payments_frequency { "monthly" }
    partner_legal_aid_payments_value { 117 }
    partner_legal_aid_payments_frequency { "every_week" }
    partner_savings { 548 }
    partner_investments { 997 }
    partner_valuables { 234 }
  end

  factory :instant_controlled_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }

    level_of_help { "controlled" }
    matter_type { "immigration" }
    asylum_support { false }
    over_60 { false }
    employment_status { "in_work" }
    partner { true }
    passporting { false }
    child_dependants { false }
    child_dependants_count { nil }
    adult_dependants { false }
    adult_dependants_count { nil }
    frequency { "week" }
    gross_income { 1.0 }
    income_tax { 0.0 }
    national_insurance { 0.0 }
    receives_benefits { true }
    benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    friends_or_family_value { 0.0 }
    friends_or_family_frequency { "every_week" }
    maintenance_value { 0.0 }
    maintenance_frequency { "every_week" }
    property_or_lodger_value { 0.0 }
    property_or_lodger_frequency { "every_week" }
    pension_value { 0.0 }
    pension_frequency { "every_week" }
    student_finance_value { 0.0 }
    other_value { 0.0 }
    housing_payments_value { nil }
    housing_payments_frequency { nil }
    childcare_payments_value { 0.0 }
    childcare_payments_frequency { "every_week" }
    maintenance_payments_value { 0.0 }
    maintenance_payments_frequency { "every_week" }
    legal_aid_payments_value { 0.0 }
    legal_aid_payments_frequency { "every_week" }
    property_value { nil }
    property_mortgage { nil }
    property_percentage_owned { nil }
    savings { 0.0 }
    investments { 0.0 }
    valuables { 0.0 }
    in_dispute { [] }
    partner_over_60 { false }
    partner_employment_status { "in_work" }
    partner_frequency { "week" }
    partner_gross_income { 1.0 }
    partner_income_tax { 0.0 }
    partner_national_insurance { 0.0 }
    partner_receives_benefits { true }
    partner_benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    partner_friends_or_family_value { 0.0 }
    partner_friends_or_family_frequency { "every_week" }
    partner_maintenance_value { 0.0 }
    partner_maintenance_frequency { "every_week" }
    partner_property_or_lodger_value { 0.0 }
    partner_property_or_lodger_frequency { "every_week" }
    partner_pension_value { 0.0 }
    partner_pension_frequency { "every_week" }
    partner_student_finance_value { 0.0 }
    partner_other_value { 0.0 }
    partner_childcare_payments_value { 0.0 }
    partner_childcare_payments_frequency { "every_week" }
    partner_maintenance_payments_value { 0.0 }
    partner_maintenance_payments_frequency { "every_week" }
    partner_legal_aid_payments_value { 0.0 }
    partner_legal_aid_payments_frequency { "every_week" }
    partner_savings { 0.0 }
    partner_investments { 0.0 }
    partner_valuables { 0.0 }
    property_owned { "outright" }
    house_value { 1.0 }
    mortgage { nil }
    percentage_owned { 1 }
    house_in_dispute { nil }
    additional_property_owned { "outright" }
    additional_house_value { 1.0 }
    additional_mortgage { nil }
    additional_percentage_owned { 1 }
    additional_house_in_dispute { nil }
    partner_additional_property_owned { "outright" }
    partner_additional_house_value { 1.0 }
    partner_additional_mortgage { nil }
    partner_additional_percentage_owned { 1 }
  end

  factory :instant_certificated_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }

    level_of_help { "certificated" }
    matter_type { "immigration" }
    asylum_support { false }
    over_60 { false }
    employment_status { "in_work" }
    partner { true }
    passporting { false }
    child_dependants { false }
    child_dependants_count { nil }
    adult_dependants { false }
    adult_dependants_count { nil }
    frequency { "week" }
    gross_income { 1.0 }
    income_tax { 0.0 }
    national_insurance { 0.0 }
    receives_benefits { true }
    benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    friends_or_family_value { 0.0 }
    friends_or_family_frequency { "every_week" }
    maintenance_value { 0.0 }
    maintenance_frequency { "every_week" }
    property_or_lodger_value { 0.0 }
    property_or_lodger_frequency { "every_week" }
    pension_value { 0.0 }
    pension_frequency { "every_week" }
    student_finance_value { 0.0 }
    other_value { 0.0 }
    housing_payments_value { nil }
    housing_payments_frequency { nil }
    childcare_payments_value { 0.0 }
    childcare_payments_frequency { "every_week" }
    maintenance_payments_value { 0.0 }
    maintenance_payments_frequency { "every_week" }
    legal_aid_payments_value { 0.0 }
    legal_aid_payments_frequency { "every_week" }
    property_value { nil }
    property_mortgage { nil }
    property_percentage_owned { nil }
    savings { 0.0 }
    investments { 0.0 }
    valuables { 0.0 }
    in_dispute { [] }
    partner_over_60 { false }
    partner_employment_status { "in_work" }
    partner_frequency { "week" }
    partner_gross_income { 1.0 }
    partner_income_tax { 0.0 }
    partner_national_insurance { 0.0 }
    partner_receives_benefits { true }
    partner_benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    partner_friends_or_family_value { 0.0 }
    partner_friends_or_family_frequency { "every_week" }
    partner_maintenance_value { 0.0 }
    partner_maintenance_frequency { "every_week" }
    partner_property_or_lodger_value { 0.0 }
    partner_property_or_lodger_frequency { "every_week" }
    partner_pension_value { 0.0 }
    partner_pension_frequency { "every_week" }
    partner_student_finance_value { 0.0 }
    partner_other_value { 0.0 }
    partner_childcare_payments_value { 0.0 }
    partner_childcare_payments_frequency { "every_week" }
    partner_maintenance_payments_value { 0.0 }
    partner_maintenance_payments_frequency { "every_week" }
    partner_legal_aid_payments_value { 0.0 }
    partner_legal_aid_payments_frequency { "every_week" }
    partner_savings { 0.0 }
    partner_investments { 0.0 }
    partner_valuables { 0.0 }
    property_owned { "outright" }
    house_value { 1.0 }
    mortgage { nil }
    percentage_owned { 1 }
    house_in_dispute { nil }
    additional_property_owned { "outright" }
    additional_house_value { 1.0 }
    additional_mortgage { nil }
    additional_percentage_owned { 1 }
    additional_house_in_dispute { nil }
    partner_additional_property_owned { "outright" }
    partner_additional_house_value { 1.0 }
    partner_additional_mortgage { nil }
    partner_additional_percentage_owned { 1 }
    vehicle_owned { true }
    vehicles do
      [{ "vehicle_value" => 1.0, "vehicle_pcp" => false, "vehicle_finance" => nil, "vehicle_over_3_years_ago" => false, "vehicle_in_regular_use" => false, "vehicle_in_dispute" => nil }]
    end
  end
end
