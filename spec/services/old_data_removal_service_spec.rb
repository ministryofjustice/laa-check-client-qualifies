require "rails_helper"

RSpec.describe OldDataRemovalService do
  it "removes data that is older than 5 years" do
    FactoryBot.create :analytics_event, created_at: 6.years.ago
    FactoryBot.create :completed_user_journey, completed: 6.years.ago
    described_class.call
    expect(AnalyticsEvent.count).to eq 0
    expect(CompletedUserJourney.count).to eq 0
  end

  it "leaves data that is newer than 5 years" do
    FactoryBot.create :analytics_event, created_at: 4.years.ago
    FactoryBot.create :completed_user_journey, completed: 4.years.ago
    described_class.call
    expect(AnalyticsEvent.count).to eq 1
    expect(CompletedUserJourney.count).to eq 1
  end
end
