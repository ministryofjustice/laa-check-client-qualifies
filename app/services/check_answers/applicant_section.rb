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
    attribute :level_of_help, :string

    class << self
      def from_session(session)
        new session.slice(*(FIELDS + [:level_of_help]))
      end
    end

    def display_fields
      disabled_fields = [
        (:proceeding_type if level_of_help == "controlled"),
      ]
      FIELDS - disabled_fields.compact
    end

    def disputed_asset?(_field)
      false
    end
  end
end
