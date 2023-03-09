class CapitalSection
  PROPERTY_STEPS = %i[property property_entry].freeze
  VEHICLE_STEPS = %i[vehicle vehicle_details].freeze
  TAIL_STEPS = %i[assets partner_assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      return [] if estimate.asylum_support_and_upper_tribunal?

      property_steps = estimate.owns_property? ? PROPERTY_STEPS : %i[property]

      ([property_steps] + [vehicle_steps(estimate)] + tail_steps(estimate)).freeze
    end

    def vehicle_steps(estimate)
      return [] if estimate.controlled?

      estimate.vehicle_owned ? VEHICLE_STEPS : %i[vehicle]
    end

    def tail_steps(estimate)
      return [[:assets]] unless estimate.partner

      [[:assets], [:partner_assets]]
    end
  end
end
