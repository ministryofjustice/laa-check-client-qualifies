FactoryBot.define do
  factory :satisfaction_feedback do
    satisfied { "no" }
    outcome { "eligible" }
    level_of_help { "controlled" }
  end
end
