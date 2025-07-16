namespace :migrate do
  desc "EL-2268: Delete unwanted data from AnalyticEvent table based on the time frame they are open"
  # Rake task to delete unwanted analytics event data.
  # Call with "rake migrate:delete_analytics_events_based_on_time_frame_open[mock]"
  # e.g. rake "migrate:delete_analytics_events_based_on_time_frame_open[false]"
  # Running with mock=true will output the number of records to be deleted without actually deleting any
  # (to allow for testing).

  task :delete_analytics_events_based_on_time_frame_open, %i[mock] => :environment do |_task, args|
    if args.count != 1
      Rails.logger.info 'call with rake "migrate:delete_analytics_events_based_on_time_frame_open[mock]"'
      next
    end

    mock = args[:mock].to_s.downcase.strip != "false"
    Rails.logger.info "delete_analytics_events_based_on_time_frame_open: mock=#{mock}"

    duration_threshold_days = 30

    targetted_codes_from_analytics_events = AnalyticsEvent
      .select("assessment_code, MIN(created_at::date) AS min_date, MAX(created_at::date) AS max_date")
      .group(:assessment_code)
      .having("MAX(created_at::date) - MIN(created_at::date) > ?", duration_threshold_days)

    assessment_codes_to_delete = targetted_codes_from_analytics_events.map(&:assessment_code)

    analytics_count = assessment_codes_to_delete.size

    if assessment_codes_to_delete.empty?
      Rails.logger.info "delete_analytics_events_based_on_time_frame_open: No events AnalyticsEvent data found, with those criteria"
    elsif mock
      Rails.logger.info "delete_analytics_events_based_on_time_frame_open: #{analytics_count} assessment codes (with multiple analytics events) for AnalyticsEvent table would have been deleted"
    else
      AnalyticsEvent.where(assessment_code: assessment_codes_to_delete).in_batches(&:delete_all)
      Rails.logger.info "delete_analytics_events_based_on_time_frame_open: #{analytics_count} assessment codes (with multiple analytics events) for AnalyticsEvent table have been deleted"
    end
    Rails.logger.info "delete_analytics_events_based_on_time_frame_open: #{AnalyticsEvent.count} AnalyticsEvent data remain"
  end
end
