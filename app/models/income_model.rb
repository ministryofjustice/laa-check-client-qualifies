class IncomeModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  STANDARD_FREQUENCY_OPTIONS = %w[every_week every_two_weeks every_four_weeks monthly].freeze
  THREE_MONTHS = "three_months".freeze
  YEAR = "year".freeze
  FREQUENCY_OPTIONS = (STANDARD_FREQUENCY_OPTIONS + [THREE_MONTHS, YEAR]).freeze
  TYPE_OPTIONS = %w[employment statutory_pay self_employment].freeze

  ATTRIBUTES = %i[income_type income_frequency gross_income income_tax national_insurance].freeze

  attribute :income_type, :string
  validates :income_type, inclusion: { in: TYPE_OPTIONS, allow_nil: false }

  attribute :income_frequency, :string
  validates :income_frequency, inclusion: { in: ->(model) { model.relevant_frequency_options }, allow_nil: false }

  attribute :gross_income, :gbp
  validates :gross_income, presence: true, numericality: { greater_than: 0, allow_nil: true }
  attribute :income_tax, :gbp
  validates :income_tax, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  attribute :national_insurance, :gbp
  validates :national_insurance, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  validate :net_income_must_be_positive

  attr_accessor :controlled, :partner

  def relevant_frequency_options
    return STANDARD_FREQUENCY_OPTIONS + [THREE_MONTHS] if controlled

    STANDARD_FREQUENCY_OPTIONS + [THREE_MONTHS, YEAR]
  end

  def income_frequency_options
    IncomeModel.income_frequency_options(skip_year: controlled)
  end

  def self.income_frequency_options(skip_year:)
    standard = STANDARD_FREQUENCY_OPTIONS.map { [_1, I18n.t("question_flow.income.frequencies.#{_1}")] }
    addendum = [:divider, [THREE_MONTHS, I18n.t("question_flow.income.frequencies.#{THREE_MONTHS}")]]
    return standard + addendum if skip_year

    standard + addendum + [[YEAR, I18n.t("question_flow.income.frequencies.#{YEAR}")]]
  end

  def income_type_options
    check_type = controlled ? "controlled" : "certificated"
    section = partner ? "partner_income" : "income"
    TYPE_OPTIONS.map { [_1, I18n.t("question_flow.income.types.#{_1}"), I18n.t("question_flow.#{section}.types.#{_1}_#{check_type}_hint")] }
  end

private

  def net_income_must_be_positive
    return if gross_income.to_i.zero?
    return unless gross_income.to_i - income_tax.to_i - national_insurance.to_i <= 0

    errors.add(:gross_income, :net_income_must_be_positive)
  end
end
