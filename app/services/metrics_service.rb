class MetricsService
  DAYS_TO_CONSIDER = 30

  def self.call
    new.call if ENV["GECKOBOARD_ENABLED"]&.casecmp("enabled")&.zero?
  end

  def call
    client = Geckoboard.client(ENV["GECKOBOARD_API_KEY"])
    metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_METRIC_DATASET_NAME", "metrics"),
                                                    **metric_dataset_definition)
    metric_dataset.put(metrics)
    validation_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_VALIDATION_DATASET_NAME", "validations"),
                                                        **validation_dataset_definition)
    validation_dataset.put(validations)
  end

private

  def metric_dataset_definition
    {
      fields: [
        Geckoboard::DateField.new(:date, name: "#{DAYS_TO_CONSIDER}-day period ending"),
        Geckoboard::NumberField.new(:assessments_started, name: "Assessments started"),
        Geckoboard::NumberField.new(:assessments_completed, name: "Assessments completed"),
        Geckoboard::NumberField.new(:percent_completed, name: "% of started assessments completed", optional: true),
        Geckoboard::NumberField.new(:assessments_per_user, name: "Average assessments started per user", optional: true),
        Geckoboard::NumberField.new(:percent_controlled, name: "% of completed assessments that are controlled", optional: true),
      ],
    }
  end

  def metrics
    [
      {
        date: 1.day.ago.to_date,
        assessments_started:,
        assessments_completed:,
        percent_completed:,
        assessments_per_user:,
        percent_controlled:,
      },
    ]
  end

  def validation_dataset_definition
    {
      fields: [
        Geckoboard::DateField.new(:date, name: "#{DAYS_TO_CONSIDER}-day period ending"),
        Geckoboard::NumberField.new(:assessments, name: "Assessments"),
        Geckoboard::StringField.new(:screen, name: "Screen on which shown"),
      ],
    }
  end

  def validations
    top_validation_screens.map do |screen_and_count|
      {
        date: 1.day.ago.to_date,
        assessments: screen_and_count[1],
        screen: screen_and_count[0],
      }
    end
  end

  def assessments_started
    @assessments_started ||= relevant_events.where.not(assessment_code: nil).count("DISTINCT assessment_code")
  end

  def assessments_completed
    @assessments_completed ||= relevant_events.where(event_type: "page_view", page: "view_results").count("DISTINCT assessment_code")
  end

  def percent_completed
    return if assessments_started.zero?

    (100 * assessments_completed / assessments_started.to_f).round
  end

  def assessments_per_user
    subset_of_events = relevant_events.where.not(assessment_code: nil).where.not(browser_id: nil)
    assessments_with_browser = subset_of_events.distinct.count(:assessment_code)
    browsers_with_assessments = subset_of_events.distinct.count(:browser_id)
    return if browsers_with_assessments.zero?

    (assessments_with_browser / browsers_with_assessments.to_f).round
  end

  def percent_controlled
    return if assessments_completed.zero?

    controlled_completed = relevant_events.joins("LEFT JOIN analytics_events ae2 ON ae2.assessment_code = analytics_events.assessment_code")
                                          .where(event_type: "page_view", page: "view_results")
                                          .where(ae2: { event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice" })
                                          .distinct
                                          .count(:assessment_code)

    (100 * controlled_completed / assessments_completed.to_f).round
  end

  def top_validation_screens
    relevant_events.where(event_type: "validation_message")
                   .group(:page)
                   .order(Arel.sql("COUNT(DISTINCT assessment_code) DESC"))
                   .limit(10)
                   .pluck(Arel.sql("page, COUNT(DISTINCT assessment_code)"))
  end

  def relevant_events
    period_end = Date.current.beginning_of_day
    AnalyticsEvent.where(created_at: (period_end - DAYS_TO_CONSIDER.days)..period_end)
  end
end
