class ControlledWorkDocumentSelection
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[form_type language].freeze

  OPTIONS = %i[cw1 cw2 cw1_and_2 cw5 civ_means_7].freeze
  LANGUAGES = %w[english welsh].freeze

  attribute :form_type, :string
  validates :form_type, presence: true, inclusion: { in: OPTIONS.map(&:to_s), allow_nil: true }

  attribute :language, :string
  validates :language, presence: true, inclusion: { in: LANGUAGES, allow_nil: true },
                       if: -> { FeatureFlags.enabled?(:welsh_cw, without_session_data: true) }

  def options
    if client_under_18_feature_flag_and_clr
      OPTIONS.select { %i[cw2 cw1_and_2].include?(_1) }
            .map { { value: _1, options: { label: { text: I18n.t("controlled_work_document_selections.new.option.#{_1}") } } } }
    else
      OPTIONS.select { !check.asylum_support || %i[cw1 cw2].include?(_1) }
            .map { { value: _1, options: { label: { text: I18n.t("controlled_work_document_selections.new.option.#{_1}") } } } }
    end
  end

  def client_under_18_feature_flag_and_clr
    FeatureFlags.enabled?(:under_eighteen, @check.session_data) && @check.session_data["controlled_legal_representation"]
  end
end
