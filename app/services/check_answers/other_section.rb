module CheckAnswers
  class OtherSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :property_value, :gbp
    attribute :savings, :gbp
    attribute :investments, :gbp
    attribute :valuables, :gbp
    attribute :property_mortgage, :gbp
    attribute :property_percentage_owned, :integer
    attribute :in_dispute, array: true, default: []

    FIELDS = %i[property_value
                property_mortgage
                property_percentage_owned
                savings
                investments
                valuables
                in_dispute].freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS)
      end
    end

    def display_fields
      @display_fields ||= FIELDS
    end

    def disputed_asset?(field)
      case field
      when :property_value
        in_dispute.include? "property"
      when :savings
        in_dispute.include? "savings"
      when :investments
        in_dispute.include? "investments"
      when :valuables
        in_dispute.include? "valuables"
      end
    end
  end
end
