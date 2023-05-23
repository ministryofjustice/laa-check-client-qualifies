class OutgoingsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  PAYMENT_TYPES = %i[housing_payments childcare_payments maintenance_payments legal_aid_payments].freeze
  VALUE_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_value" }.freeze
  FREQUENCY_ATTRIBUTES = PAYMENT_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  PAYMENT_TYPES.each do |payment_type|
    value_attribute = :"#{payment_type}_value"
    frequency_attribute = :"#{payment_type}_frequency"
    attribute value_attribute, :gbp
    attribute frequency_attribute, :string

    if payment_type == :housing_payments
      validates value_attribute, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, unless: :house_section_enabled?
    else
      validates value_attribute, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
    end

    if payment_type == :housing_payments
      validates frequency_attribute, presence: true,
                                     inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                     if: -> { send(value_attribute).to_i.positive? },
                                     unless: :house_section_enabled?
    else
      validates frequency_attribute, presence: true,
                                     inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                     if: -> { send(value_attribute).to_i.positive? }
    end
  end

  delegate :level_of_help, to: :check

  def frequencies
    valid_frequencies = level_of_help == "controlled" ? VALID_FREQUENCIES - %w[total] : VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("estimate_flow.outgoings.frequencies.#{_1}")] }
  end

  def house_section_enabled?
    FeatureFlags.enabled?(:household_section)
  end
end
