class PartnerCapitalSection
  VEHICLE_STEPS = %i[partner_vehicle partner_vehicle_details].freeze
  TAIL_STEPS = %i[partner_assets].freeze

  class << self
    def all_steps
      (VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      return [] unless estimate.partner

      vehicle_steps = estimate.partner_vehicle_owned ? VEHICLE_STEPS : %i[partner_vehicle]

      ([vehicle_steps] + TAIL_STEPS.map { |step| [step] }).freeze
    end
  end
end
