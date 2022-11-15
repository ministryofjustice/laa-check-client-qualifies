module CheckAnswers
  class OtherIncomeSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :friends_or_family_value, :gbp
    attribute :maintenance_value, :gbp
    attribute :property_or_lodger_value, :gbp
    attribute :pension_value, :gbp
    attribute :other_value, :gbp
    attribute :student_finance_value, :gbp

    FIELDS = %i[friends_or_family_value
                maintenance_value
                property_or_lodger_value
                pension_value
                other_value
                student_finance_value].freeze

    class << self
      def from_session(session_data)
        new session_data.slice(*FIELDS)
      end
    end

    def display_fields
      @display_fields ||= FIELDS
    end

    def disputed_asset?(_field)
      false
    end
  end
end
