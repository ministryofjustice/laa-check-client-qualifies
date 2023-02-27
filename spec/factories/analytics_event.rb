FactoryBot.define do
  factory :analytics_event do
    page { "index_start" }
    event_type { "page_view" }
  end
end
