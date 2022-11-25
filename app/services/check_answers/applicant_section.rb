module CheckAnswers
  class ApplicantSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    FIELDS = %i[over_60
                partner
                employed].freeze

    attribute :over_60, :boolean
    attribute :partner, :boolean
    attribute :employed, :boolean
    attribute :passporting, :boolean

    class << self
      def from_session(session)
        new session.slice(*FIELDS)
      end
    end

    def display_fields
      Flipper.enabled?(:partner) ? FIELDS : FIELDS - %i[partner]
    end

    def disputed_asset?(_field)
      false
    end
  end
end
