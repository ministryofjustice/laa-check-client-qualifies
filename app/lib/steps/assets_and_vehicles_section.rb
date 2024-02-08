module Steps
  class AssetsAndVehiclesSection
    VEHICLE_STEPS = %i[vehicle vehicles_details].freeze
    ASSET_STEPS = %i[assets partner_assets].freeze

    class << self
      def all_steps
        (ASSET_STEPS + VEHICLE_STEPS).freeze
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)

        return [] if logic.skip_capital_questions?

        if logic.partner?
          [Steps::Group.new(:assets),
           Steps::Group.new(:partner_assets),
           vehicle_steps(logic)].compact
        else
          [Steps::Group.new(:assets),
           vehicle_steps(logic)].compact
        end
      end

      def vehicle_steps(logic)
        return if logic.controlled?

        steps = logic.owns_vehicle? ? %i[vehicle vehicles_details] : %i[vehicle]
        Steps::Group.new(*steps)
      end
    end
  end
end
