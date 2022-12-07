class EmploymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  DECIMAL_ATTRIBUTES = %i[gross_income income_tax national_insurance].freeze
  ATTRIBUTES = (DECIMAL_ATTRIBUTES + %i[frequency]).freeze

  DECIMAL_ATTRIBUTES.each do |attribute|
    attribute attribute, :gbp
    validates attribute, presence: true
  end

  validate :net_income_must_be_positive

  attribute :frequency, :string
  validates :frequency, presence: true

  FREQUENCY_OPTIONS = %i[week two_weeks four_weeks monthly total annually].freeze

  def frequency_options
    FREQUENCY_OPTIONS.map do |key|
      OpenStruct.new(value: key, label: I18n.t("estimate_flow.employment.frequency.#{key}"))
    end
  end

private

  def net_income_must_be_positive
    if gross_income.to_i - income_tax.to_i - national_insurance.to_i <= 0
      errors.add(:gross_income, :net_income_must_be_positive)
    end
  end
end
