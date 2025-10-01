class OldDataRemovalService
  def self.call
    cutoff = 5.years.ago
    AnalyticsEvent.where("created_at < ?", cutoff).delete_all
    CompletedUserJourney.where("completed < ?", cutoff).delete_all
  end
end
