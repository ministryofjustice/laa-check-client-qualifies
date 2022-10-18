class CapitalSection
  FIRST_VEHICLE_STEPS = %i[vehicle vehicle_value].freeze
  REGULAR_USE_VEHICLE_STEPS = %i[vehicle_age vehicle_finance].freeze
  ALL_VEHICLE_STEPS = (FIRST_VEHICLE_STEPS + REGULAR_USE_VEHICLE_STEPS).freeze

  TAIL_STEPS = %i[assets check_answers].freeze

  VEHICLE_RULES = {
    vehicle_not_owned: %i[vehicle].freeze,
    vehicle_owned: FIRST_VEHICLE_STEPS,
    vehicle_regular: ALL_VEHICLE_STEPS,
  }.freeze

  class << self
    def all_steps
      (%i[property property_entry] + ALL_VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def step_should_save?(model, step)
      steps_list = steps_for(model).detect { |list| list.include?(step) }
      step == steps_list.last
    end

    def steps_for(estimate)
      property_steps = estimate.owned? ? %i[property property_entry] : %i[property]

      vehicle_rules_key = if estimate.vehicle_owned
                            if estimate.vehicle_in_regular_use
                              :vehicle_regular
                            else
                              :vehicle_owned
                            end
                          else
                            :vehicle_not_owned
                          end

      vehicle_steps = VEHICLE_RULES.fetch(vehicle_rules_key)

      ([property_steps] + [vehicle_steps] + TAIL_STEPS.map { |step| [step] }).freeze
    end
  end
end
