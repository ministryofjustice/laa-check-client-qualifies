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
          Geckoboard::NumberField.new(:with_partner_overall, name: "Completed checks with partner"),
          Geckoboard::NumberField.new(:with_partner_certificated, name: "Completed certificated checks with partner"),
          Geckoboard::NumberField.new(:with_partner_controlled, name: "Completed controlled checks with partner"),
          Geckoboard::NumberField.new(:no_partner_overall, name: "Completed checks without partner"),
          Geckoboard::NumberField.new(:no_partner_certificated, name: "Completed certificated checks without partner"),
          Geckoboard::NumberField.new(:no_partner_controlled, name: "Completed controlled checks without partner"),
          Geckoboard::NumberField.new(:over_60_overall, name: "Completed checks with person over 60"),
          Geckoboard::NumberField.new(:over_60_certificated, name: "Completed certificated checks with person over 60"),
          Geckoboard::NumberField.new(:over_60_controlled, name: "Completed controlled checks with person over 60"),
          Geckoboard::NumberField.new(:passported_overall, name: "Completed checks with passporting benefit"),
          Geckoboard::NumberField.new(:passported_certificated, name: "Completed certificated checks with passporting benefit"),
          Geckoboard::NumberField.new(:passported_controlled, name: "Completed controlled checks with passporting benefit"),
          Geckoboard::NumberField.new(:non_passported_overall, name: "Completed checks without passporting benefit"),
          Geckoboard::NumberField.new(:non_passported_certificated, name: "Completed certificated checks without passporting benefit"),
          Geckoboard::NumberField.new(:non_passported_controlled, name: "Completed controlled checks without passporting benefit"),
          Geckoboard::NumberField.new(:property_overall, name: "Completed checks with owned property"),
          Geckoboard::NumberField.new(:property_certificated, name: "Completed certificated checks with owned property"),
          Geckoboard::NumberField.new(:property_controlled, name: "Completed controlled checks with owned property"),
          Geckoboard::NumberField.new(:vehicle_overall, name: "Completed checks with owned vehicle"),
          Geckoboard::NumberField.new(:vehicle_certificated, name: "Completed certificated checks with owned vehicle"),
          Geckoboard::NumberField.new(:vehicle_controlled, name: "Completed controlled checks with owned vehicle"),
          Geckoboard::NumberField.new(:smod_overall, name: "Completed checks with SMOD assets"),
          Geckoboard::NumberField.new(:smod_certificated, name: "Completed certificated checks with SMOD assets"),
          Geckoboard::NumberField.new(:smod_controlled, name: "Completed controlled checks with SMOD assets"),
          Geckoboard::NumberField.new(:eligible_overall, name: "Completed checks with eligible result"),
          Geckoboard::NumberField.new(:eligible_certificated, name: "Completed certificated checks with eligible result"),
          Geckoboard::NumberField.new(:eligible_controlled, name: "Completed controlled checks with eligible result"),
          Geckoboard::NumberField.new(:ineligible_overall, name: "Completed checks with ineligible result"),
          Geckoboard::NumberField.new(:ineligible_certificated, name: "Completed certificated checks with ineligible result"),
          Geckoboard::NumberField.new(:ineligible_controlled, name: "Completed controlled checks with ineligible result"),
          Geckoboard::NumberField.new(:capital_contribution_overall, name: "Completed checks with capital contribution required"),
          Geckoboard::NumberField.new(:capital_contribution_certificated, name: "Completed certificated checks with capital contribution required"),
          Geckoboard::NumberField.new(:capital_contribution_controlled, name: "Completed controlled checks with capital contribution required"),
          Geckoboard::NumberField.new(:income_contribution_overall, name: "Completed checks with income contribution required"),
          Geckoboard::NumberField.new(:income_contribution_certificated, name: "Completed certificated checks with income contribution required"),
          Geckoboard::NumberField.new(:income_contribution_controlled, name: "Completed controlled checks with income contribution required"),
        ],
      }
    end

    def metrics
      # We produce a dataset with two rows in it, one which contains values for the current month and one
      # with values for all time. The latter's values will by definition be greater than or equal to
      # the former's, and this allows us to specify which to display in Geckoboard's widget editor
      # by choosing 'Max' and 'Min' aggregate options
      %i[all_time month_to_date].map do |range|
        build_row_for(range)
      end
    end

    def build_row_for(range)
      METRIC_TO_ATTRIBUTE_MAPPINGS.map { |prefix, relevant_attributes| build_columns_for(prefix, relevant_attributes, range) }.reduce({}, :merge)
    end

    def build_columns_for(prefix, relevant_attributes, range)
      {
        "#{prefix}_overall": count(range, relevant_attributes),
        "#{prefix}_certificated": count(range, relevant_attributes.merge(certificated: true)),
        "#{prefix}_controlled": count(range, relevant_attributes.merge(certificated: false)),
      }
    end

    def count(range, attributes)
      extra_attributes = {}
      extra_attributes[:completed] = Date.current.all_month if range == :month_to_date
      extra_attributes[:certificated] = [true, false] unless attributes.key?(:certificated)
      CompletedUserJourney.where(attributes.merge(extra_attributes)).count
    end
  end
end
