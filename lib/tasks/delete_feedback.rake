namespace :migrate do
  desc "EL-2213: Delete unwanted feedback from Satisfaction Feedback table"
  # Rake task to delete unwanted feedback.
  # Call with "rake migrate:delete_feecback[mock, 'start_date_time', 'end_date_time']"
  # e.g. rake "migrate:delete_feedback[false, '2025-04-24 14:26:00', '2025-04-24 14:27:00']"
  # Running with mock=true will output the number of records to be deleted without actually deleting any
  # (to allow for testing).

  task :delete_feedback, %i[mock start_date_time end_date_time] => :environment do |_task, args|
    if args.count != 3
      Rails.logger.info "call with rake migrate:delete_feecback[mock, start_date_time, end_date_time]"
      next
    end

    mock = args[:mock].to_s.downcase.strip != "false"
    start_date_time = Time.zone.parse(args[:start_date_time])
    end_date_time = Time.zone.parse(args[:end_date_time])
    Rails.logger.info "delete_feedback: mock=#{mock}, start_date_time=#{start_date_time}, end_date_time=#{end_date_time}"
    satisfaction_feedbacks = SatisfactionFeedback.where("created_at > ? and created_at < ?", start_date_time, end_date_time)
    feedbacks_count = satisfaction_feedbacks.count
    Rails.logger.info "delete_feedback: Deleting #{feedbacks_count} satisfaction feedbacks"
    satisfaction_feedbacks.in_batches(&:delete_all) unless mock
    Rails.logger.info "delete_feedback: #{feedbacks_count} satisfaction feedbacks deleted"
    Rails.logger.info "delete_feedback: #{satisfaction_feedbacks.count} satisfaction feedbacks remaining"
  end
end
