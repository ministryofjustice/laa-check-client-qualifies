FactoryBot.define do
  factory :minimal_complete_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }
    client_age { "standard" }
    level_of_help { "certificated" }
    domestic_abuse_applicant { false }
    immigration_or_asylum_type_upper_tribunal { "none" }
    over_60 { false }
    employment_status { "unemployed" }
    partner { false }
    passporting { false }
    child_dependants { false }
    child_dependants_count { nil }
    adult_dependants { false }
    adult_dependants_count { nil }
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
    bank_accounts { [{ "amount" => 0, "account_in_dispute" => false }] }
    investments { 0 }
    valuables { 0 }
    investments_in_dispute { false }
    valuables_in_dispute { false }

    trait :with_conditional_housing_benefit do
      housing_benefit_relevant { false }
    end

    trait :with_asylum_support do
      immigration_or_asylum_type_upper_tribunal { "immigration_upper" }
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

    trait :with_partner_income_outgoings_data do
      partner_employment_status { "in_work" }
      partner_frequency { "week" }
      partner_gross_income { 10 }
      partner_income_tax { 4 }
      partner_national_insurance { 5 }
      partner_benefits do
        [
          { "id" => "a7b72db5-2c4d-4f04-a7c8-4b5adae1bfa0",
            "benefit_type" => "bbb",
            "benefit_amount" => 6,
            "benefit_frequency" => "monthly" },
        ]
      end
      partner_add_benefit { false }
      partner_friends_or_family_value { 0 }
      partner_maintenance_value { 0 }
      partner_property_or_lodger_value { 0 }
      partner_pension_value { 0 }
      partner_student_finance_value { 0 }
      partner_other_value { 0 }
      partner_childcare_payments_value { 0 }
      partner_maintenance_payments_value { 0 }
      partner_legal_aid_payments_value { 0 }
    end

    trait :with_partner_assets_information do
      partner_bank_accounts { [{ "amount" => 10 }, { "amount" => 5 }] }
      partner_investments { 0 }
      partner_valuables { 0 }
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
      bank_accounts { [{ "amount" => 0, "account_in_dispute" => false }] }
      investments { 0 }
      valuables { 0 }
      investments_in_dispute { false }
      valuables_in_dispute { false }
    end
  end

  factory :full_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }
    client_age { "standard" }
    level_of_help { "certificated" }
    domestic_abuse_applicant { false }
    immigration_or_asylum_type_upper_tribunal { "none" }
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
    bank_accounts { [{ "amount" => 553, "account_in_dispute" => true }] }
    investments { 345 }
    valuables { 665 }
    investments_in_dispute { true }
    valuables_in_dispute { true }
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
    partner_bank_accounts { [{ "amount" => 548 }] }
    partner_investments { 997 }
    partner_valuables { 234 }

    trait :with_conditional_housing_benefit do
      housing_benefit_relevant { true }
    end
  end

  factory :instant_controlled_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }
    client_age { "standard" }
    level_of_help { "controlled" }
    immigration_or_asylum { "true" }
    immigration_or_asylum_type { "immigration_clr" }
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
    incomes do
      [{ "income_type" => "employment", "gross_income" => 1.0, "income_tax" => 0, "national_insurance" => 0, "income_frequency" => "every_week" }]
    end
    receives_benefits { true }
    benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    friends_or_family_relevant { false }
    maintenance_relevant { false }
    property_or_lodger_relevant { false }
    pension_relevant { false }
    student_finance_relevant { false }
    other_relevant { false }
    childcare_payments_relevant { false }
    maintenance_payments_relevant { false }
    legal_aid_payments_relevant { false }
    housing_payments_value { nil }
    housing_payments_frequency { nil }
    property_value { nil }
    property_mortgage { nil }
    property_percentage_owned { nil }
    bank_accounts { [{ "amount" => 0, "account_in_dispute" => false }] }
    investments { 0.0 }
    valuables { 0.0 }
    investments_in_dispute { false }
    valuables_in_dispute { false }
    partner_over_60 { false }
    partner_employment_status { "in_work" }
    partner_frequency { "week" }
    partner_gross_income { 1.0 }
    partner_income_tax { 0.0 }
    partner_national_insurance { 0.0 }
    partner_incomes do
      [{ "income_type" => "employment", "gross_income" => 1.0, "income_tax" => 0, "national_insurance" => 0, "income_frequency" => "every_week" }]
    end
    partner_receives_benefits { true }
    partner_benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    partner_friends_or_family_relevant { false }
    partner_maintenance_relevant { false }
    partner_property_or_lodger_relevant { false }
    partner_pension_relevant { false }
    partner_student_finance_relevant { false }
    partner_other_relevant { false }
    partner_childcare_payments_relevant { false }
    partner_maintenance_payments_relevant { false }
    partner_legal_aid_payments_relevant { false }
    partner_bank_accounts { [{ "amount" => 0 }] }
    partner_investments { 0.0 }
    partner_valuables { 0.0 }
    property_owned { "outright" }
    house_value { 1.0 }
    mortgage { nil }
    percentage_owned { 1 }
    house_in_dispute { nil }
    additional_property_owned { "with_mortgage" }
    additional_properties do
      [{ "house_value" => 1.0, "mortgage" => 1.0, "percentage_owned" => 1, "house_in_dispute" => false }]
    end
    partner_additional_property_owned { "with_mortgage" }
    partner_additional_properties do
      [{ "house_value" => 1.0, "mortgage" => 1.0, "percentage_owned" => 1 }]
    end
  end

  factory :instant_certificated_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }
    client_age { "standard" }
    level_of_help { "certificated" }
    domestic_abuse_applicant { false }
    immigration_or_asylum_type_upper_tribunal { "immigration_upper" }
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
    incomes do
      [{ "income_type" => "employment", "gross_income" => 1.0, "income_tax" => 0, "national_insurance" => 0, "income_frequency" => "every_week" }]
    end
    receives_benefits { true }
    benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    friends_or_family_relevant { false }
    maintenance_relevant { false }
    property_or_lodger_relevant { false }
    pension_relevant { false }
    student_finance_relevant { false }
    other_relevant { false }
    childcare_payments_relevant { false }
    maintenance_payments_relevant { false }
    legal_aid_payments_relevant { false }
    housing_payments_value { nil }
    housing_payments_frequency { nil }
    property_value { nil }
    property_mortgage { nil }
    property_percentage_owned { nil }
    bank_accounts { [{ "amount" => 0, "account_in_dispute" => false }] }
    investments { 0.0 }
    valuables { 0.0 }
    investments_in_dispute { false }
    valuables_in_dispute { false }
    partner_over_60 { false }
    partner_employment_status { "in_work" }
    partner_frequency { "week" }
    partner_gross_income { 1.0 }
    partner_income_tax { 0.0 }
    partner_national_insurance { 0.0 }
    partner_incomes do
      [{ "income_type" => "employment", "gross_income" => 1.0, "income_tax" => 0, "national_insurance" => 0, "income_frequency" => "every_week" }]
    end
    partner_receives_benefits { true }
    partner_benefits do
      [{ "benefit_type" => "Benefit", "benefit_amount" => 1.0, "benefit_frequency" => "every_week" }]
    end
    partner_friends_or_family_relevant { false }
    partner_maintenance_relevant { false }
    partner_property_or_lodger_relevant { false }
    partner_pension_relevant { false }
    partner_student_finance_relevant { false }
    partner_other_relevant { false }
    partner_childcare_payments_relevant { false }
    partner_maintenance_payments_relevant { false }
    partner_legal_aid_payments_relevant { false }
    partner_bank_accounts { [{ "amount" => 0 }] }
    partner_investments { 0.0 }
    partner_valuables { 0.0 }
    property_owned { "outright" }
    house_value { 1.0 }
    mortgage { nil }
    percentage_owned { 1 }
    house_in_dispute { nil }
    additional_property_owned { "with_mortgage" }
    additional_properties do
      [{ "house_value" => 1.0, "mortgage" => 1.0, "percentage_owned" => 1, "house_in_dispute" => false }]
    end
    partner_additional_property_owned { "with_mortgage" }
    partner_additional_properties do
      [{ "house_value" => 1.0, "mortgage" => 1.0, "percentage_owned" => 1 }]
    end
    vehicle_owned { true }
    vehicles do
      [{ "vehicle_value" => 1.0, "vehicle_pcp" => false, "vehicle_finance" => nil, "vehicle_over_3_years_ago" => false, "vehicle_in_regular_use" => false, "vehicle_in_dispute" => nil }]
    end
  end

  factory :rich_instant_controlled_session, class: Hash do
    initialize_with { attributes.transform_keys(&:to_s) }
    client_age { "standard" }
    level_of_help { "controlled" }
    immigration_or_asylum { false }
    over_60 { false }
    partner { true }
    passporting { false }
    child_dependants { true }
    child_dependants_count { 2 }
    adult_dependants { true }
    adult_dependants_count { 1 }
    dependants_get_income { true }
    dependant_incomes do
      [{ "amount" => 60.0, "frequency" => "monthly" }]
    end
    employment_status { "in_work" }
    incomes do
      [{ "income_type" => "employment", "gross_income" => 1200.0, "income_tax" => 60.0, "national_insurance" => 9.0, "income_frequency" => "monthly" }]
    end
    receives_benefits { true }
    benefits do
      [{ "benefit_type" => "Child Benefit", "benefit_amount" => 80.0, "benefit_frequency" => "every_four_weeks" }]
    end
    friends_or_family_relevant { false }
    maintenance_relevant { false }
    property_or_lodger_relevant { false }
    pension_relevant { false }
    student_finance_relevant { false }
    other_relevant { false }
    childcare_payments_relevant { true }
    maintenance_payments_relevant { false }
    legal_aid_payments_relevant { true }
    housing_payments { 1200.0 }
    housing_payments_frequency { "monthly" }
    housing_benefit_relevant { true }
    housing_benefit_value { 100 }
    housing_benefit_frequency { "monthly" }
    childcare_payments_conditional_value { 80.0 }
    childcare_payments_frequency { "every_four_weeks" }
    legal_aid_payments_conditional_value { 10.0 }
    legal_aid_payments_frequency { "monthly" }
    property_value { nil }
    property_mortgage { nil }
    property_percentage_owned { nil }
    bank_accounts { [{ "amount" => 400.0, "account_in_dispute" => false }] }
    investments { 0.0 }
    valuables { 1000.0 }
    investments_in_dispute { false }
    valuables_in_dispute { false }
    partner_over_60 { true }
    partner_employment_status { "in_work" }
    partner_frequency { "week" }
    partner_gross_income { 1.0 }
    partner_income_tax { 0.0 }
    partner_national_insurance { 0.0 }
    partner_incomes do
      [{ "income_type" => "self_employment", "gross_income" => 100.0, "income_tax" => 3.0, "national_insurance" => 2.0, "income_frequency" => "every_week" },
       { "income_type" => "self_employment", "gross_income" => 800.0, "income_tax" => 20.0, "national_insurance" => 3.0, "income_frequency" => "monthly" }]
    end
    partner_receives_benefits { true }
    partner_benefits do
      [{ "benefit_type" => "Working Tax Credit", "benefit_amount" => 80.0, "benefit_frequency" => "monthly" }]
    end
    partner_friends_or_family_relevant { false }
    partner_maintenance_relevant { false }
    partner_property_or_lodger_relevant { false }
    partner_pension_relevant { false }
    partner_student_finance_relevant { false }
    partner_other_relevant { false }
    partner_childcare_payments_relevant { false }
    partner_maintenance_payments_relevant { false }
    partner_legal_aid_payments_relevant { false }
    partner_bank_accounts { [{ "amount" => 500.0 }] }
    partner_investments { 0.0 }
    partner_valuables { 0.0 }
    property_owned { "none" }
    additional_property_owned { "none" }
    partner_additional_property_owned { "outright" }
    partner_additional_properties do
      [{ "house_value" => 2000.0, "percentage_owned" => 100 }]
    end

    trait :with_conditional_housing_benefit do
      housing_benefit_relevant { true }
    end
  end
end
