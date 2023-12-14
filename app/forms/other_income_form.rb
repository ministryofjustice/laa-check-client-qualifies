class OtherIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  REGULAR_INCOME_TYPES = %i[friends_or_family maintenance property_or_lodger pension].freeze
  IRREGULAR_INCOME_TYPES = %i[student_finance other].freeze
  BOOLEAN_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_relevant" }.freeze
  VALUE_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_value" }.freeze
  CONDITIONAL_VALUE_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_conditional_value" }.freeze
  FREQUENCY_ATTRIBUTES = REGULAR_INCOME_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = BOOLEAN_ATTRIBUTES + VALUE_ATTRIBUTES + CONDITIONAL_VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).each do |income_type|
    boolean_attribute = :"#{income_type}_relevant"
    value_attribute = :"#{income_type}_value"
    conditional_value_attribute = :"#{income_type}_conditional_value"

    attribute boolean_attribute, :boolean
    validates boolean_attribute, inclusion: { in: [true, false] }, if: -> { FeatureFlags.enabled?(:conditional_reveals, check.session_data) }

    attribute value_attribute, :gbp
    validates value_attribute, presence: true,
                               numericality: { greater_than_or_equal_to: 0, allow_nil: true },
                               is_a_number: true,
                               if: -> { !FeatureFlags.enabled?(:conditional_reveals, check.session_data) }

    attribute conditional_value_attribute, :gbp
    validates conditional_value_attribute, presence: true,
                                           numericality: { greater_than: 0, allow_nil: true },
                                           is_a_number: true,
                                           if: -> { FeatureFlags.enabled?(:conditional_reveals, check.session_data) && send(boolean_attribute) }

    next unless REGULAR_INCOME_TYPES.include?(income_type)

    frequency_attribute = :"#{income_type}_frequency"
    attribute frequency_attribute, :string

    validates frequency_attribute, presence: true,
                                   inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                   if: -> { (!FeatureFlags.enabled?(:conditional_reveals, check.session_data) && send(value_attribute).to_i.positive?) || send(boolean_attribute) }
  end

  delegate :level_of_help, to: :check

  def frequencies
    valid_frequencies = level_of_help == "controlled" ? VALID_FREQUENCIES - %w[total] : VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.other_income.frequencies.#{_1}")] }
  end
end
