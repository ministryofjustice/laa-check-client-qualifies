class CapitalSection
  PROPERTY_STEPS = %i[property property_entry].freeze
  VEHICLE_STEPS = %i[vehicle vehicle_details].freeze
  TAIL_STEPS = %i[assets check_answers].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(estimate)
      property_steps = estimate.owned? ? PROPERTY_STEPS : %i[property]
      vehicle_steps = estimate.vehicle_owned ? VEHICLE_STEPS : %i[vehicle]

      ([property_steps] + [vehicle_steps] + TAIL_STEPS.map { |step| [step] }).freeze
    end
  end
end
