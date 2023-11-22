class ControlledWorkDocumentSelection
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[form_type language].freeze

  OPTIONS = if client_under_18_and_clr
              %i[cw2 cw1_and_2].freeze
            else
              %i[cw1 cw2 cw1_and_2 cw5 civ_means_7].freeze
            end

  LANGUAGES = %w[english welsh].freeze

  attribute :form_type, :string
  validates :form_type, presence: true, inclusion: { in: OPTIONS.map(&:to_s), allow_nil: true }

  attribute :language, :string
  validates :language, presence: true, inclusion: { in: LANGUAGES, allow_nil: true },
                       if: -> { FeatureFlags.enabled?(:welsh_cw, without_session_data: true) }

  # Based on the IncomeModel class
  # Will need to change :level_of_help to whatever the CLR option is
  attr_accessor :level_of_help

  # My thinking is that this checks if feature flag is on and then level of help is true
  # Will need to change :level_of_help to whatever the CLR option is
  def client_under_18_and_clr
    FeatureFlags.enabled?(:under_eighteen, @check.session_data) && level_of_help == "clr"
  end
end
