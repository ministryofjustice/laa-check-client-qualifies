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
  validates :language, presence: true, inclusion: { in: LANGUAGES, allow_nil: true }

  def options
    cw_form_radio_button_option = if check.controlled_legal_representation
                                    %i[cw2 cw1_and_2].freeze
                                  elsif check.asylum_support
                                    %i[cw1 cw2].freeze
                                  else
                                    OPTIONS
                                  end

    cw_form_radio_button_option.map { { value: _1, options: { label: { text: I18n.t("controlled_work_document_selections.new.option.#{_1}") } } } }
  end
end
