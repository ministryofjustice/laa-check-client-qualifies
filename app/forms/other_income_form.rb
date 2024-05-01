class OtherIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  REGULAR_INCOME_TYPES = %i[friends_or_family maintenance property_or_lodger pension].freeze
  IRREGULAR_INCOME_TYPES = %i[student_finance other].freeze
  BOOLEAN_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_relevant" }.freeze
  CONDITIONAL_VALUE_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_conditional_value" }.freeze
  FREQUENCY_ATTRIBUTES = REGULAR_INCOME_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly total].freeze

  ATTRIBUTES = BOOLEAN_ATTRIBUTES + CONDITIONAL_VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).each do |income_type|
    boolean_attribute = :"#{income_type}_relevant"
    conditional_value_attribute = :"#{income_type}_conditional_value"

    attribute boolean_attribute, :boolean
    validates boolean_attribute, inclusion: { in: [true, false] }
    next if income_type == :other

    attribute conditional_value_attribute, :gbp
    validates conditional_value_attribute, presence: true,
                                           numericality: { greater_than: 0, allow_nil: true },
                                           is_a_number: true,
                                           if: -> { send(boolean_attribute) }

    next unless REGULAR_INCOME_TYPES.include?(income_type)

    frequency_attribute = :"#{income_type}_frequency"
    attribute frequency_attribute, :string
  end
  attribute :other_conditional_value, :gbp
  validate :custom_validation_other_conditional_value

  delegate :level_of_help, to: :check

  def frequencies
    valid_frequencies = level_of_help == "controlled" ? VALID_FREQUENCIES - %w[total] : VALID_FREQUENCIES
    valid_frequencies.map { [_1, I18n.t("question_flow.other_income.frequencies.#{_1}")] }
  end

  def custom_validation_other_conditional_value
    if send("other_relevant")
      if other_conditional_value.blank?
        errors.add(:other_conditional_value, I18n.t("activemodel.errors.models.other_income_form.attributes.other_conditional_value.blank_#{level_of_help}"))
      elsif !other_conditional_value.is_a?(Numeric)
        errors.add(:other_conditional_value, I18n.t("activemodel.errors.models.other_income_form.attributes.other_conditional_value.not_a_number_#{level_of_help}"))
      elsif !other_conditional_value.to_i.positive?
        errors.add(:other_conditional_value, I18n.t("activemodel.errors.models.other_income_form.attributes.other_conditional_value.greater_than_#{level_of_help}"))
      end
    end
  end
end
