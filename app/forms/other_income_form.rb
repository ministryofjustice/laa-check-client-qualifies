class OtherIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  REGULAR_INCOME_TYPES = %i[friends_or_family maintenance property_or_lodger pension].freeze
  IRREGULAR_INCOME_TYPES = %i[student_finance other].freeze
  VALUE_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_value" }.freeze
  FREQUENCY_ATTRIBUTES = REGULAR_INCOME_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).each do |income_type|
    value_attribute = :"#{income_type}_value"

    attribute value_attribute, :gbp
    validates value_attribute, presence: true,
                               numericality: { greater_than_or_equal_to: 0, allow_nil: true }

    next unless REGULAR_INCOME_TYPES.include?(income_type)

    frequency_attribute = :"#{income_type}_frequency"
    attribute frequency_attribute, :string

    validates frequency_attribute, presence: true,
                                   inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                   if: -> { send(value_attribute).to_i.positive? }
  end

  delegate :level_of_help, to: :estimate

  def frequencies
    valid_frequencies = level_of_help == "controlled" ? VALID_FREQUENCIES - %w[total] : VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("estimate_flow.other_income.frequencies.#{_1}")] }
  end
end
