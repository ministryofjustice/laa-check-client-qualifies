namespace :migrate do
  desc "EL-2268: Delete unwanted data from AnalyticEvent table based on assessment code"
  # Rake task to delete unwanted analytics event data.
  # Call with "rake migrate:delete_analytics_events_based_on_assessment_code[mock]"
  # e.g. rake "migrate:delete_analytics_events_based_on_assessment_code[false]"
  # Running with mock=true will output the number of records to be deleted without actually deleting any
  # (to allow for testing).

  task :delete_analytics_events_based_on_assessment_code, %i[mock] => :environment do |_task, args|
    if args.count != 1
      Rails.logger.info 'call with rake "migrate:delete_analytics_events_based_on_assessment_code[mock]"'
      next
    end

    mock = args[:mock].to_s.downcase.strip != "false"
    Rails.logger.info "delete_analytics_events_based_on_assessment_code: mock=#{mock}"

    codes_to_delete = %w[
      b5123acb-3582-4dad-9021-0eb6e0bc527f
      789874e6-a388-4f45-beab-927e1cc8a3d2
      2d99ea5a-8350-49bf-b0d2-3f6cca958c0f
    ]

    targetted_codes_from_analytics_events = AnalyticsEvent.where(assessment_code: codes_to_delete)
    analytics_count = targetted_codes_from_analytics_events.count

    if analytics_count.zero?
      Rails.logger.info "delete_analytics_events_based_on_assessment_code: No events AnalyticsEvent data found, with those criteria"
    elsif mock
      targetted_codes_from_analytics_events.in_batches(&:delete_all)
      Rails.logger.info "delete_analytics_events_based_on_assessment_code: #{analytics_count} AnalyticsEvent data deleted"
    else
      Rails.logger.info "delete_analytics_events_based_on_assessment_code: #{analytics_count} AnalyticsEvent data would have been deleted"
    end
    Rails.logger.info "delete_analytics_events_based_on_assessment_code: #{AnalyticsEvent.count} AnalyticsEvent data remain"
  end
end
