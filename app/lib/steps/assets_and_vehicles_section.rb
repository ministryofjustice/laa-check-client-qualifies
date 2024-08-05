module Steps
  class AssetsAndVehiclesSection
    VEHICLE_STEPS = %i[vehicle vehicles_details].freeze
    ASSET_STEPS = %i[assets partner_assets].freeze

    class << self
      def all_steps
        (ASSET_STEPS + VEHICLE_STEPS).freeze
      end

      def grouped_steps_for(session_data)
        return [] if Steps::Logic.skip_capital_questions?(session_data)

        if Steps::Logic.partner?(session_data)
          [Steps::Group.new(:assets),
           Steps::Group.new(:partner_assets),
           vehicle_steps(session_data)].compact
        else
          [Steps::Group.new(:assets),
           vehicle_steps(session_data)].compact
        end
      end

      def vehicle_steps(session_data)
        return if Steps::Logic.controlled?(session_data)

        steps = Check.new(session_data).owns_vehicle? ? %i[vehicle vehicles_details] : %i[vehicle]
        Steps::Group.new(*steps)
      end
    end
  end
end
