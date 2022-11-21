class OutgoingsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PAYMENT_TYPES = %i[housing_payments childcare_payments maintenance_payments legal_aid_payments].freeze
  VALUE_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_value" }.freeze
  FREQUENCY_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly].freeze

  ATTRIBUTES = VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  PAYMENT_TYPES.each do |payment_type|
    value_attribute = :"#{payment_type}_value"
    frequency_attribute = :"#{payment_type}_frequency"
    attribute value_attribute, :gbp
    attribute frequency_attribute, :string

    validates value_attribute, presence: true
    validates frequency_attribute, presence: true,
                                   inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                   if: -> { send(value_attribute)&.positive? }
  end

  def frequencies
    VALID_FREQUENCIES.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
  end
end
