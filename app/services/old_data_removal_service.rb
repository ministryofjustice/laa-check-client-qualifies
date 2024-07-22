class OldDataRemovalService
  def self.call
    cutoff = 5.years.ago
    AnalyticsEvent.where("created_at < ?", cutoff).delete_all
    CompletedUserJourney.where("completed < ?", cutoff).delete_all

    # storing Provider from the Portal is a bit annoying -
    # so for data protection purposes we are just deleting them
    # once a week. This might have to stop once this is used as a foreign
    # key into other tables e.g. saved checks but for now this is fine
    Provider.where("created_at < ?", 1.week.ago).delete_all
  end
end
