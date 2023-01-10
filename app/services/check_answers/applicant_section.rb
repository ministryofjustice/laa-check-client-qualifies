module CheckAnswers
  class ApplicantSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    FIELDS = %i[proceeding_type
                over_60
                partner
                employed
                passporting].freeze

    attribute :over_60, :boolean
    attribute :partner, :boolean
    attribute :employed, :boolean
    attribute :passporting, :boolean
    attribute :proceeding_type, :string

    class << self
      def from_session(session)
        new session.slice(*FIELDS)
      end
    end

    def display_fields
      FeatureFlags.enabled?(:partner) ? FIELDS : FIELDS - %i[partner]
    end

    def disputed_asset?(_field)
      false
    end
  end
end
