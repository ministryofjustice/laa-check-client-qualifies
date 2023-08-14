module Metrics
  class ForUserJourneyDashboardService
    def self.call
      return if CompletedUserJourney.none?

      new.call
    end

    def call
      client = Geckoboard.client(ENV["GECKOBOARD_API_KEY"])
      all_metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_ALL_JOURNEYS_DATASET_NAME", "all_journeys"),
                                                          **metric_dataset_definition(date: false))
      all_metric_dataset.put(all_metrics)

      monthly_metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_MONTHLY_JOURNEYS_DATASET_NAME", "monthly_journeys"),
                                                              **metric_dataset_definition(date: false))
      monthly_metric_dataset.put(monthly_metrics)

      recent_metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_RECENT_JOURNEYS_DATASET_NAME", "recent_journeys"),
                                                             **metric_dataset_definition(date: true))
      recent_metric_dataset.put(recent_metrics)
    end

  private

    PARTNER_LAUNCH_DATE = Date.new(2023, 3, 31)

    METRIC_TO_ATTRIBUTE_MAPPINGS = {
      combined_eligible_including_contributions: { criteria: { outcome: %w[eligible contribution_required] } },
      combined_eligible_no_contribution: { criteria: { outcome: "eligible" } },
      combined_income_contribution: { criteria: { income_contribution: true } },
      combined_capital_contribution: { criteria: { capital_contribution: true } },
      combined_ineligible: { criteria: { outcome: "ineligible" } },
      certificated_eligible_no_contribution: { criteria: { outcome: "eligible" }, scope: { certificated: true } },
      certificated_income_contribution: { criteria: { income_contribution: true }, scope: { certificated: true } },
      certificated_capital_contribution: { criteria: { capital_contribution: true }, scope: { certificated: true } },
      certificated_ineligible: { criteria: { outcome: "ineligible" }, scope: { certificated: true } },
      controlled_eligible: { criteria: { outcome: "eligible" }, scope: { certificated: false } },
      controlled_ineligible: { criteria: { outcome: "ineligible" }, scope: { certificated: false } },
      combined_partner: { criteria: { partner: true }, scope: { completed: (PARTNER_LAUNCH_DATE..) } },
      combined_passported: { criteria: { passported: true } },
      combined_over_60: { criteria: { person_over_60: true } },
      certificated_partner: { criteria: { partner: true }, scope: { certificated: true, completed: (PARTNER_LAUNCH_DATE..) } },
      certificated_passported: { criteria: { passported: true }, scope: { certificated: true } },
      certificated_over_60: { criteria: { person_over_60: true }, scope: { certificated: true } },
      controlled_partner: { criteria: { partner: true }, scope: { certificated: false, completed: (PARTNER_LAUNCH_DATE..) } },
      controlled_passported: { criteria: { passported: true }, scope: { certificated: false } },
      controlled_over_60: { criteria: { person_over_60: true }, scope: { certificated: false } },
      certificated_immigration: { criteria: { matter_type: "immigration" }, scope: { certificated: true, matter_type: %w[immigration asylum domestic_abuse other] } },
      certificated_asylum: { criteria: { matter_type: "asylum" }, scope: { certificated: true, matter_type: %w[immigration asylum domestic_abuse other] } },
      certificated_domestic_abuse: { criteria: { matter_type: "domestic_abuse" }, scope: { certificated: true, matter_type: %w[immigration asylum domestic_abuse other] } },
      certificated_other: { criteria: { matter_type: "other" }, scope: { certificated: true, matter_type: %w[immigration asylum domestic_abuse other] } },
      controlled_immigration: { criteria: { matter_type: %i[immigration_clr immigration_legal_help] }, scope: { certificated: false, matter_type: %w[immigration_clr immigration_legal_help asylum other] } },
      controlled_asylum: { criteria: { matter_type: "asylum" }, scope: { certificated: false, matter_type: %w[immigration_clr immigration_legal_help asylum other] } },
      controlled_other: { criteria: { matter_type: "other" }, scope: { certificated: false, matter_type: %w[immigration_clr immigration_legal_help asylum other] } },
    }.freeze

    def metric_dataset_definition(date: true)
      number_fields = METRIC_TO_ATTRIBUTE_MAPPINGS.keys.map { Geckoboard::NumberField.new(_1, name: _1.to_s.humanize, optional: true) }
      {
        fields: [
          (Geckoboard::DateField.new(:date, name: "Month beginning") if date),
          *number_fields,
        ].compact,
      }
    end

    def all_metrics
      [
        METRIC_TO_ATTRIBUTE_MAPPINGS.transform_values { build_percentage_for(_1, CompletedUserJourney) },
      ]
    end

    def recent_metrics
      [
        METRIC_TO_ATTRIBUTE_MAPPINGS.transform_values { build_percentage_for(_1, CompletedUserJourney.where(completed: (30.days.ago..))) },
      ]
    end

    def monthly_metrics
      date_ranges.map do |range|
        METRIC_TO_ATTRIBUTE_MAPPINGS.transform_values { build_count_for(_1, CompletedUserJourney.where(completed: range)) }.merge(date: range.first.to_date)
      end
    end

    def build_percentage_for(data, records_in_time_range)
      relevant_journeys = data[:scope] ? records_in_time_range.where(data[:scope]) : records_in_time_range
      return if relevant_journeys.none?

      (100 * relevant_journeys.where(data[:criteria]).count / relevant_journeys.count.to_f).round
    end

    def build_count_for(data, records_in_time_range)
      relevant_journeys = data[:scope] ? records_in_time_range.where(data[:scope]) : records_in_time_range
      relevant_journeys.where(data[:criteria]).count
    end

    def date_ranges
      end_date = Time.zone.today

      dates = []
      date = CompletedUserJourney.minimum(:completed).beginning_of_month

      while date <= end_date.beginning_of_month
        dates << date.all_month
        date += 1.month
      end

      dates
    end
  end
end
