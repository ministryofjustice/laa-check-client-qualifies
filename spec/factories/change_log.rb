FactoryBot.define do
  factory :change_log do
    title { "Update to with childcare costs" }
    content { "<div class=\"trix-content\"><p>Childcare costs are changing.</p></div>" }
    published { true }
    tag { nil }
    released_on { 1.day.ago }
  end
end
