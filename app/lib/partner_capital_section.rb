class PartnerCapitalSection
  PROPERTY_STEPS = %i[partner_property partner_property_entry].freeze
  VEHICLE_STEPS = %i[partner_vehicle partner_vehicle_details].freeze
  TAIL_STEPS = %i[partner_assets].freeze

  class << self
    def all_steps
      (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
    end

    def steps_for(session_data)
      if !StepsLogic.partner?(session_data)
        []
      else
        ([property_steps(session_data)] + [vehicle_steps(session_data)] + TAIL_STEPS.map { |step| [step] }).freeze
      end
    end

    def property_steps(session_data)
      if StepsLogic.owns_property?(session_data)
        []
      elsif StepsLogic.partner_owns_property?(session_data)
        PROPERTY_STEPS
      else
        %i[partner_property]
      end
    end

    def vehicle_steps(session_data)
      return [] if StepsLogic.controlled?(session_data)

      StepsLogic.partner_owns_vehicle?(session_data) ? VEHICLE_STEPS : %i[partner_vehicle]
    end
  end
end
