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

    FIELDS = %i[vehicle_value
                vehicle_pcp
                vehicle_owned
                vehicle_finance
                vehicle_in_dispute
                vehicle_in_regular_use
                vehicle_over_3_years_ago].freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS)
      end
    end

    def display_fields
      if vehicle_owned
        if vehicle_pcp
          FIELDS
        else
          FIELDS - [:vehicle_finance]
        end
      else
        [:vehicle_owned]
      end
    end

    def disputed_asset?(field)
      vehicle_owned && vehicle_in_dispute if field == :vehicle_owned
    end
  end
end
