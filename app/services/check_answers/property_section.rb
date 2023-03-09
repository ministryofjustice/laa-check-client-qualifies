module CheckAnswers
  class PropertySection
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :partner
    attribute :property_owned, :string
    attribute :house_value, :decimal
    attribute :mortgage, :decimal
    attribute :percentage_owned, :integer
    attribute :house_in_dispute, :boolean

    FIELDS = %i[property_owned house_value mortgage percentage_owned house_in_dispute].freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS + [:partner])
      end
    end

    def display_fields
      if owns_property?
        FIELDS
      else
        [:property_owned]
      end
    end

    def disputed_asset?(field)
      owns_property? && house_in_dispute if field == :property_owned
    end

    def mortgage
      attributes.fetch("mortgage") if property_owned == "with_mortgage"
    end

  private

    def owns_property?
      %i[with_mortgage outright].map(&:to_s).include? property_owned
    end
  end
end
