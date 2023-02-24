class CapitalSection
  PROPERTY_STEPS = %i[property property_entry].freeze
  VEHICLE_STEPS = %i[vehicle vehicle_details].freeze
  TAIL_STEPS = %i[assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      if estimate.asylum_support
        []
      else
        property_steps = estimate.owns_property? ? PROPERTY_STEPS : %i[property]

        ([property_steps] + [vehicle_steps(estimate)] + TAIL_STEPS.map { |step| [step] }).freeze
      end
    end

    def vehicle_steps(estimate)
      return [] if estimate.controlled?

      estimate.vehicle_owned ? VEHICLE_STEPS : %i[vehicle]
    end
  end
end
