class EmploymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  DECIMAL_ATTRIBUTES = %i[gross_income income_tax national_insurance].freeze
  ATTRIBUTES = (DECIMAL_ATTRIBUTES + %i[frequency]).freeze

  delegate :level_of_help, to: :check

  FREQUENCY_STANDARD_OPTIONS = %i[week two_weeks four_weeks monthly].freeze
  FREQUENCY_TOTAL_OPTION = :total
  FREQUENCY_OPTIONS = (FREQUENCY_STANDARD_OPTIONS + [FREQUENCY_TOTAL_OPTION]).freeze

  attribute :frequency, :string
  validates :frequency, presence: true, inclusion: { in: FREQUENCY_OPTIONS.map(&:to_s), allow_nil: true }

  validate :net_income_must_be_positive

  DECIMAL_ATTRIBUTES.each do |attribute|
    numericality = attribute == :gross_income ? { greater_than: 0, allow_nil: true } : { greater_than_or_equal_to: 0, allow_nil: true }
    attribute attribute, :gbp
    validates attribute, presence: true, numericality:
  end

private

  def net_income_must_be_positive
    return if gross_income.to_i.zero?
    return unless gross_income.to_i - income_tax.to_i - national_insurance.to_i <= 0

    errors.add(:gross_income, :net_income_must_be_positive)
  end
end
