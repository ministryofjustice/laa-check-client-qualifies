class CapitalSection
  PROPERTY_STEPS = %i[property property_entry].freeze
  VEHICLE_STEPS = %i[vehicle vehicle_details].freeze
  TAIL_STEPS = %i[assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(session_data)
      return [] if StepsLogic.asylum_supported?(session_data)

      property_steps = StepsLogic.owns_property?(session_data) ? PROPERTY_STEPS : %i[property]

      ([property_steps] + [vehicle_steps(session_data)] + TAIL_STEPS.map { |step| [step] }).freeze
    end

    def vehicle_steps(session_data)
      return [] if StepsLogic.controlled?(session_data)

      StepsLogic.owns_vehicle?(session_data) ? VEHICLE_STEPS : %i[vehicle]
    end
  end
end
