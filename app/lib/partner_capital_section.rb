class PartnerCapitalSection
  PROPERTY_STEPS = %i[partner_property partner_property_entry].freeze
  VEHICLE_STEPS = %i[partner_vehicle partner_vehicle_details].freeze
  TAIL_STEPS = %i[partner_assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      return [] unless estimate.partner

      property_steps = if estimate.owns_property?
                         []
                       elsif estimate.partner_owns_property?
                         PROPERTY_STEPS
                       else
                         %i[partner_property]
                       end

      ([property_steps] + [vehicle_steps(estimate)] + TAIL_STEPS.map { |step| [step] }).freeze
    end

    def vehicle_steps(estimate)
      return [] if estimate.controlled?

      estimate.partner_vehicle_owned ? VEHICLE_STEPS : %i[partner_vehicle]
    end
  end
end
