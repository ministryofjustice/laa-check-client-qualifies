module CheckAnswers
  class PropertySection
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :property_owned, :string
    attribute :house_value, :decimal
    attribute :mortgage, :decimal
    attribute :percentage_owned, :integer
    attribute :house_in_dispute, :boolean
    attribute :joint_ownership, :boolean
    attribute :joint_percentage_owned, :integer

    FIELDS = %i[property_owned house_value mortgage percentage_owned house_in_dispute joint_ownership joint_percentage_owned].freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS)
      end
    end

    def display_fields
      if owns_property?
        Flipper.enabled?(:partner) ? FIELDS : FIELDS - %i[joint_ownership joint_percentage_owned]
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
