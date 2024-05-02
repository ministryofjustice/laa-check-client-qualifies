class OutgoingsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PAYMENT_TYPES = %i[childcare_payments maintenance_payments legal_aid_payments].freeze
  BOOLEAN_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_relevant" }.freeze
  CONDITIONAL_VALUE_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_conditional_value" }.freeze
  VALUE_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_value" }.freeze
  FREQUENCY_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = BOOLEAN_ATTRIBUTES + CONDITIONAL_VALUE_ATTRIBUTES + VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  PAYMENT_TYPES.each do |payment_type|
    boolean_attribute = :"#{payment_type}_relevant"
    conditional_value_attribute = :"#{payment_type}_conditional_value"
    value_attribute = :"#{payment_type}_value"
    frequency_attribute = :"#{payment_type}_frequency"

    attribute boolean_attribute, :boolean
    attribute value_attribute, :gbp
    attribute conditional_value_attribute, :gbp
    attribute frequency_attribute, :string

    validates boolean_attribute, inclusion: { in: [true, false] }, if: -> { payment_type != :childcare_payments || eligible_for_childcare_costs? }
    validates conditional_value_attribute,
              presence: true,
              numericality: { greater_than: 0, allow_nil: true },
              is_a_number: true,
              if: -> { send(boolean_attribute) && (payment_type != :childcare_payments || eligible_for_childcare_costs?) }

    # !FeatureFlags.enabled?(:conditional_reveals) will always be false, so these validations dont ever happen
    # hence we are removing them, but I am not 100% certain so I am commenting them out for now
    # validates value_attribute,
    #           presence: true,
    #           numericality: { greater_than_or_equal_to: 0, allow_nil: true },
    #           is_a_number: true,
    #           if: -> { !FeatureFlags.enabled?(:conditional_reveals, check.session_data) && (payment_type != :childcare_payments || eligible_for_childcare_costs?) }
    # validates frequency_attribute, presence: true,
    #                                inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
    #                                if: -> { (!FeatureFlags.enabled?(:conditional_reveals, check.session_data) && send(value_attribute).to_i.positive?) || send(boolean_attribute) }
  end

  delegate :level_of_help, :eligible_for_childcare_costs?, to: :check

  def frequencies
    valid_frequencies = level_of_help == "controlled" ? VALID_FREQUENCIES - %w[total] : VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.outgoings.frequencies.#{_1}")] }
  end
end
