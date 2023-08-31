FactoryBot.define do
  factory :issue do
    title { "Problem with childcare costs" }
    banner_content { "We have identified a problem with childcare costs." }
    status { "active" }
  end

  factory :issue_update do
    issue
    content { "We are working to resolve the problem." }
  end
end
