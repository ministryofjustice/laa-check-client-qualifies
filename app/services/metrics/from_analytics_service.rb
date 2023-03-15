module Metrics
  class FromAnalyticsService
    def self.call
      new.call
    end

    def call
      client = Geckoboard.client(ENV["GECKOBOARD_API_KEY"])
      metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_METRIC_DATASET_NAME", "monthly_metrics"),
                                                      **metric_dataset_definition)
      metric_dataset.put(metrics)

      all_metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_ALL_METRIC_DATASET_NAME", "all_metrics"),
                                                          **metric_dataset_definition)
      all_metric_dataset.put(all_metrics)

      last_page_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_LAST_PAGE_DATASET_NAME", "last_pages"),
                                                         **last_page_dataset_definition)
      last_page_dataset.put(last_pages)
      validation_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_VALIDATION_DATASET_NAME", "validations"),
                                                          **validation_dataset_definition)
      validation_dataset.put(validations.flatten)
    end

  private

    def metric_dataset_definition
      {
        fields: [
          Geckoboard::DateField.new(:date, name: "Month beginning"),
          Geckoboard::NumberField.new(:checks_started, name: "Checks started"),
          Geckoboard::NumberField.new(:checks_completed, name: "Checks completed"),
          Geckoboard::NumberField.new(:completion_rate, name: "Completion rate", optional: true),
          Geckoboard::NumberField.new(:controlled_checks_completed, name: "Controlled checks completed", optional: true),
          Geckoboard::NumberField.new(:certificated_checks_completed, name: "Certificated checks completed", optional: true),
          Geckoboard::NumberField.new(:completed_checks_per_user, name: "Completed checks per (analytics opted-in) user", optional: true),
          Geckoboard::NumberField.new(:mode_completion_time_controlled, name: "Mode of time taken to complete a controlled check", optional: true),
          Geckoboard::NumberField.new(:mode_completion_time_certificated, name: "Mode of time taken to complete a certificated check", optional: true),
        ],
      }
    end

    def metrics
      earliest_date = AnalyticsEvent.minimum(:created_at)
      return [] unless earliest_date

      date_ranges(earliest_date).map do |range|
        {
          date: range.first.to_date,
          checks_started: checks_started(range),
          checks_completed: checks_completed(range),
          completion_rate: completion_rate(range),
          controlled_checks_completed: controlled_checks_completed(range),
          certificated_checks_completed: certificated_checks_completed(range),
          completed_checks_per_user: completed_checks_per_user(range),
          mode_completion_time_controlled: mode_completion_time(:controlled, range),
          mode_completion_time_certificated: mode_completion_time(:certificated, range),
        }
      end
    end

    def all_metrics
      # While many overall metrics can be derived by summing the monthly metrics in Geckoboard,
      # some can't. Notably the sum of all monthly % values, like completion rate, is not equal
      # to the overall % value. So for simplicity, and particularly given Geckoboard's limited
      # query capabilities, we send all overall data to Geckoboard separately
      [
        {
          date: Date.current,
          checks_started:,
          checks_completed:,
          completion_rate:,
          controlled_checks_completed:,
          certificated_checks_completed:,
          completed_checks_per_user:,
          mode_completion_time_controlled: mode_completion_time(:controlled),
          mode_completion_time_certificated: mode_completion_time(:certificated),
        },
      ]
    end

    def validation_dataset_definition
      {
        fields: [
          Geckoboard::NumberField.new(:checks, name: "Assessments"),
          Geckoboard::StringField.new(:screen, name: "Screen on which shown"),
          Geckoboard::StringField.new(:data_type, name: "Whether this is current month or all time"),
        ],
      }
    end

    def validations
      %i[current_month all_time].map do |time_period|
        top_validation_screens(time_period).map do |screen_and_count|
          {
            checks: screen_and_count[1],
            screen: screen_and_count[0],
            data_type: time_period,
          }
        end
      end
    end

    def last_page_dataset_definition
      {
        fields: [
          Geckoboard::NumberField.new(:checks, name: "Checks"),
          Geckoboard::StringField.new(:screen, name: "Last screen viewed"),
          Geckoboard::StringField.new(:context, name: "Context of the numbers applied"),
        ],
      }
    end

    def last_pages
      [
        exit_pages(:controlled, :all_time),
        exit_pages(:certificated, :all_time),
        exit_pages(:controlled, :current_month),
        exit_pages(:certificated, :current_month),
      ].flatten
    end

    def checks_started(range = nil)
      relevant_events(range).where.not(assessment_code: nil).count("DISTINCT assessment_code")
    end

    def checks_completed(range = nil)
      relevant_events(range).where(event_type: "page_view", page: "view_results").count("DISTINCT assessment_code")
    end

    def completion_rate(range = nil)
      started = checks_started(range)
      return if started.zero?

      (100 * checks_completed(range) / started.to_f).round
    end

    def completed_checks_per_user(range = nil)
      subset_of_events = relevant_events(range).where.not(assessment_code: nil).where.not(browser_id: nil)
      checks_with_browser = subset_of_events.distinct.count(:assessment_code)
      browsers_with_checks = subset_of_events.distinct.count(:browser_id)
      return if browsers_with_checks.zero?

      (checks_with_browser / browsers_with_checks.to_f).round
    end

    def controlled_checks_completed(range = nil)
      relevant_events(range).joins("LEFT JOIN analytics_events ae2 ON ae2.assessment_code = analytics_events.assessment_code")
                            .where(event_type: "page_view", page: "view_results")
                            .where(ae2: { event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice" })
                            .distinct
                            .count(:assessment_code)
    end

    def certificated_checks_completed(range = nil)
      checks_completed(range) - controlled_checks_completed(range)
    end

    def top_validation_screens(time_period)
      events = case time_period
               when :current_month
                 relevant_events(Date.current.all_month)
               else
                 AnalyticsEvent
               end
      events.where(event_type: "validation_message")
            .group(:page)
            .order(Arel.sql("COUNT(DISTINCT assessment_code) DESC"))
            .limit(10)
            .pluck(Arel.sql("page, COUNT(DISTINCT assessment_code)"))
    end

    def mode_completion_time(level_of_help, range = nil)
      completed_checks = level_of_help == :controlled ? controlled_checks_completed(range) : certificated_checks_completed(range)
      return if completed_checks.zero?

      start_date = range ? range.first : 100.years.ago
      end_date = range ? range.last : Time.current
      choice = "#{level_of_help}_level_of_help_chosen"

      # returns the mode_completion_time in minutes
      sql = <<~SQL
        SELECT MODE() WITHIN GROUP (ORDER BY durations.duration_in_minutes) AS mode_completion_time
        FROM
          (
            SELECT ROUND(EXTRACT(epoch FROM (completed_checks.end_time - completed_checks.start_time)) / 60) AS duration_in_minutes
            FROM
            (
              SELECT ae1.assessment_code, MIN(ae1.created_at) AS start_time, MIN(ae2.created_at) AS end_time
              FROM analytics_events ae1
              JOIN analytics_events ae2 ON ae1.assessment_code = ae2.assessment_code
              JOIN analytics_events level_of_help_filter ON level_of_help_filter.assessment_code = ae1.assessment_code
              WHERE ae1.assessment_code IS NOT NULL AND ae2.page = 'view_results' AND ae2.created_at > ae1.created_at
              AND ae1.created_at BETWEEN :start_date AND :end_date
              AND level_of_help_filter.page = 'level_of_help_choice'
              AND level_of_help_filter.event_type = :choice
              GROUP BY ae1.assessment_code
            ) AS completed_checks
          ) AS durations;
      SQL

      result = ActiveRecord::Base.connection.execute(ApplicationRecord.sanitize_sql([sql, { start_date:, end_date:, choice: }]))
      result[0]["mode_completion_time"].to_f
    end

    def relevant_events(range)
      return AnalyticsEvent unless range

      AnalyticsEvent.where(created_at: range)
    end

    def date_ranges(earliest_date)
      end_date = Time.zone.today

      dates = []
      date = earliest_date.beginning_of_month

      while date <= end_date.beginning_of_month
        dates << date.all_month
        date += 1.month
      end

      dates
    end

    def exit_pages(level_of_help, period)
      query_exit_pages(level_of_help, period).map do |result|
        {
          checks: result["checks"],
          screen: result["page"],
          context: "#{level_of_help}_#{period}",
        }
      end
    end

    QUERY = "
    SELECT   last_pages.page AS page, COUNT(last_pages.page) AS checks
    FROM     (
                SELECT    last_page_events.page
                FROM      analytics_events last_page_events
                LEFT JOIN analytics_events level_of_help_filter
                ON        level_of_help_filter.assessment_code = last_page_events.assessment_code
                LEFT JOIN analytics_events incomplete_check_filter
                ON        incomplete_check_filter.assessment_code = last_page_events.assessment_code
                AND       incomplete_check_filter.event_type = 'page_view'
                AND       incomplete_check_filter.page = 'view_results'
                LEFT JOIN analytics_events time_filter
                ON        time_filter.assessment_code = last_page_events.assessment_code
                WHERE     last_page_events.event_type = 'page_view'
                AND       last_page_events.created_at = (
                            SELECT MAX(created_at)
                            FROM   analytics_events journey
                            WHERE  journey.event_type = 'page_view'
                            AND    last_page_events.assessment_code = journey.assessment_code
                          )
                AND       level_of_help_filter.page = 'level_of_help_choice'
                AND       level_of_help_filter.event_type = :choice
                AND       incomplete_check_filter.id IS NULL
                AND       time_filter.created_at BETWEEN :range_start AND :range_end
                GROUP BY  last_page_events.assessment_code, last_page_events.page
             ) last_pages
    GROUP BY last_pages.page
    ORDER BY COUNT(last_pages.page) DESC
    LIMIT    10
    ".freeze

    def query_exit_pages(level_of_help, period)
      choice = "#{level_of_help}_level_of_help_chosen"
      range_start = period == :current_month ? Date.current.beginning_of_month : 100.years.ago
      range_end = Time.current
      ActiveRecord::Base.connection.execute(
        ApplicationRecord.sanitize_sql([QUERY, { choice:, range_start:, range_end: }]),
      )
    end
  end
end
