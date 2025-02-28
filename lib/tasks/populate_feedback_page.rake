namespace :migrate do
  desc "EL-2064: Data migration to backfill page field on Satisfaction Feedback table"
  task populate_feedback_pages: :environment do
    satisfaction_feedbacks = SatisfactionFeedback.where(page: nil)
    feedbacks_count = satisfaction_feedbacks.count
    Rails.logger.info "populate_feedback_pages: Updating #{feedbacks_count} satisfaction feedback pages"
    satisfaction_feedbacks.find_each do |feedback|
      page_name = feedback.level_of_help == "controlled" ? "end_of_journey_checks" : "show_results"
      feedback.update!(page: page_name)
    end
    Rails.logger.info "populate_feedback_pages: #{feedbacks_count} satisfaction feedback pages updated"
    Rails.logger.info "populate_feedback_pages: #{satisfaction_feedbacks.count} blank satisfaction feedback pages remaining"
  end
end
