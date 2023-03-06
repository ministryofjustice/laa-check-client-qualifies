class EmploymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  DECIMAL_ATTRIBUTES = %i[gross_income income_tax national_insurance].freeze
  ATTRIBUTES = (DECIMAL_ATTRIBUTES + %i[frequency]).freeze

  attr_accessor :level_of_help

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

  class << self
    def from_session(session_data)
      super(session_data).tap { set_level_of_help(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_level_of_help(_1, session_data) }
    end

    def set_level_of_help(form, session_data)
      form.level_of_help = session_data["level_of_help"]
    end
  end

private

  def net_income_must_be_positive
    return if gross_income.to_i.zero?
    return unless gross_income.to_i - income_tax.to_i - national_insurance.to_i <= 0

    errors.add(:gross_income, :net_income_must_be_positive)
  end
end
