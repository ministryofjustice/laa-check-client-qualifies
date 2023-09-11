FactoryBot.define do
  factory :banner do
    title { "Update to with childcare costs" }
    content { "<div class=\"trix-content\"><p>Childcare costs are changing.</p></div>" }
    published { true }
    display_from_utc { 1.day.ago }
    display_until_utc { 1.day.from_now }
  end
end
