module CheckAnswers
  class ApplicantSection
    include ActiveModel::Model
    include ActiveModel::Attributes

    FIELDS = %i[domestic_abuse
                over_60
                partner
                employed
                passporting].freeze

    attribute :over_60, :boolean
    attribute :partner, :boolean
    attribute :employed, :boolean
    attribute :passporting, :boolean
    attribute :proceeding_type

    def domestic_abuse
      proceeding_type == ApplicantForm::PROCEEDING_TYPES[:domestic_abuse]
    end

    class << self
      def from_session(session)
        new session.slice(*FIELDS + [:proceeding_type])
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
