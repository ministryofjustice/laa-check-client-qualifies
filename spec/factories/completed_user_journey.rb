FactoryBot.define do
  factory :completed_user_journey do
    assessment_id { SecureRandom.uuid }
    certificated { false }
    partner { false }
    person_over_60 { false }
    passported { false }
    main_dwelling_owned { false }
    vehicle_owned { false }
    smod_assets { false }
    outcome { "eligible" }
    capital_contribution { false }
    income_contribution { false }
  end
end
