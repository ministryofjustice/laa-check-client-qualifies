class OtherIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  REGULAR_INCOME_TYPES = %i[friends_or_family maintenance property_or_lodger pension].freeze
  IRREGULAR_INCOME_TYPES = %i[student_finance other].freeze
  VALUE_ATTRIBUTES = (REGULAR_INCOME_TYPES + IRREGULAR_INCOME_TYPES).map { :"#{_1}_value" }.freeze
  FREQUENCY_ATTRIBUTES = REGULAR_INCOME_TYPES.map { :"#{_1}_frequency" }.freeze
  VALID_FREQUENCIES = %w[every_week every_two_weeks every_four_weeks monthly].freeze

  ATTRIBUTES = VALUE_ATTRIBUTES + FREQUENCY_ATTRIBUTES

  VALUE_ATTRIBUTES.each do |value_attribute|
    attribute value_attribute, :gbp
    validates value_attribute, presence: true
  end

  REGULAR_INCOME_TYPES.each do |income_type|
    value_attribute = :"#{income_type}_value"
    frequency_attribute = :"#{income_type}_frequency"
    attribute frequency_attribute, :string

    validates frequency_attribute, presence: true,
                                   inclusion: { in: VALID_FREQUENCIES, allow_nil: false },
                                   if: -> { send(value_attribute)&.positive? }
  end
end
