module Metrics
  class FromCompletedJourneysService
    def self.call
      return if CompletedUserJourney.none?

      new.call
    end

    def call
      client = Geckoboard.client(ENV["GECKOBOARD_API_KEY"])
      metric_dataset = client.datasets.find_or_create(ENV.fetch("GECKOBOARD_JOURNEYS_DATASET_NAME", "journeys"),
                                                      **metric_dataset_definition)
      metric_dataset.put(metrics)
    end

  private

    METRIC_TO_ATTRIBUTE_MAPPINGS = {
      with_partner: { partner: true },
      no_partner: { partner: false },
      over_60: { person_over_60: true },
      passported: { passported: true },
      non_passported: { passported: false },
      property: { main_dwelling_owned: true },
      vehicle: { vehicle_owned: true },
      smod: { smod_assets: true },
      eligible: { outcome: "eligible" },
      ineligible: { outcome: "ineligible" },
      capital_contribution: { outcome: "contribution_required", capital_contribution: true },
      income_contribution: { outcome: "contribution_required", income_contribution: true },
    }.freeze

    def metric_dataset_definition
      {
        fields: [
          Geckoboard::StringField.new(:property, name: "The property in question"),
          Geckoboard::StringField.new(:metric_variant, name: "What about the property we're measuring"),
          Geckoboard::NumberField.new(:checks, name: "The measurement"),
        ],
      }
    end

    def metrics
      METRIC_TO_ATTRIBUTE_MAPPINGS.map { |property, relevant_attributes| build_rows_for(property, relevant_attributes) }.flatten
    end

    def build_rows_for(property, relevant_attributes)
      [
        build_columns_for(property, relevant_attributes, :certificated, :all_time),
        build_columns_for(property, relevant_attributes, :controlled, :all_time),
        build_columns_for(property, relevant_attributes, :certificated, :month_to_date),
        build_columns_for(property, relevant_attributes, :controlled, :month_to_date),
      ]
    end

    def build_columns_for(property, relevant_attributes, level_of_help, range)
      {
        property: property.to_s,
        metric_variant: "#{level_of_help == :certificated ? 'Certificated' : 'Controlled'} #{range == :all_time ? 'all time' : 'this month'}",
        checks: count(range, level_of_help, relevant_attributes),
      }
    end

    def count(range, level_of_help, attributes)
      extra_attributes = { certificated: level_of_help == :certificated }
      extra_attributes[:completed] = Date.current.all_month if range == :month_to_date
      CompletedUserJourney.where(attributes.merge(extra_attributes)).count
    end
  end
end
