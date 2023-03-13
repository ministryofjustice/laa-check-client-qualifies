module CheckAnswers
  class VehicleSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :vehicle_pcp, :boolean
    attribute :vehicle_finance, :gbp
    attribute :vehicle_over_3_years_ago, :boolean
    attribute :vehicle_value, :gbp
    attribute :vehicle_in_regular_use, :boolean
    attribute :vehicle_in_dispute, :boolean
    attribute :vehicle_owned, :boolean
    attribute :additional_vehicle_pcp, :boolean
    attribute :additional_vehicle_finance, :gbp
    attribute :additional_vehicle_over_3_years_ago, :boolean
    attribute :additional_vehicle_value, :gbp
    attribute :additional_vehicle_in_regular_use, :boolean
    attribute :additional_vehicle_in_dispute, :boolean
    attribute :additional_vehicle_owned, :boolean

    VEHICLE_FIELDS = %i[vehicle_value
                        vehicle_pcp
                        vehicle_owned
                        vehicle_finance
                        vehicle_in_dispute
                        vehicle_in_regular_use
                        vehicle_over_3_years_ago].freeze
    ADDITIONAL_VEHICLE_FIELDS = %i[additional_vehicle_value
                                   additional_vehicle_pcp
                                   additional_vehicle_owned
                                   additional_vehicle_finance
                                   additional_vehicle_in_dispute
                                   additional_vehicle_in_regular_use
                                   additional_vehicle_over_3_years_ago].freeze

    FIELDS = (VEHICLE_FIELDS + ADDITIONAL_VEHICLE_FIELDS).freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS)
      end
    end

    def display_fields
      vehicle_fields + additional_vehicle_fields
    end

    def vehicle_fields
      if vehicle_owned
        if vehicle_pcp
          VEHICLE_FIELDS
        else
          VEHICLE_FIELDS - [:vehicle_finance]
        end
      else
        [:vehicle_owned]
      end
    end

    def additional_vehicle_fields
      if additional_vehicle_owned
        if additional_vehicle_pcp
          ADDITIONAL_VEHICLE_FIELDS
        else
          ADDITIONAL_VEHICLE_FIELDS - [:additional_vehicle_finance]
        end
      else
        []
      end
    end

    def disputed_asset?(field)
      case field
      when :vehicle_owned
        vehicle_owned && vehicle_in_dispute
      when :additional_vehicle_owned
        additional_vehicle_owned && additional_vehicle_in_dispute
      else
        false
      end
    end
  end
end
