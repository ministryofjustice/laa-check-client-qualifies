class EmploymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  DECIMAL_ATTRIBUTES = %i[gross_income income_tax national_insurance].freeze
  ATTRIBUTES = (DECIMAL_ATTRIBUTES + %i[frequency]).freeze

  attribute :frequency, :string
  validates :frequency, presence: true

  validate :net_income_must_be_positive

  DECIMAL_ATTRIBUTES.each do |attribute|
    numericality = attribute == :gross_income ? { greater_than: 0, allow_nil: true } : { greater_than_or_equal_to: 0, allow_nil: true }
    attribute attribute, :gbp
    validates attribute, presence: true, numericality:
  end

  FREQUENCY_OPTIONS = %i[week two_weeks four_weeks monthly total annually].freeze

  def frequency_options
    FREQUENCY_OPTIONS.map do |key|
      OpenStruct.new(value: key, label: I18n.t("estimate_flow.employment.frequency.#{key}"))
    end
  end

private

  def net_income_must_be_positive
    return if gross_income.to_i.zero?
    return unless gross_income.to_i - income_tax.to_i - national_insurance.to_i <= 0

    errors.add(:gross_income, :net_income_must_be_positive)
  end
end
