class EmploymentForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  DECIMAL_ATTRIBUTES = %i[gross_income income_tax national_insurance].freeze
  EMPLOYMENT_ATTRIBUTES = (DECIMAL_ATTRIBUTES + %i[frequency]).freeze

  DECIMAL_ATTRIBUTES.each do |attribute|
    attribute attribute, :decimal
    validates attribute, presence: true
  end

  attribute :frequency, :string
  validates :frequency, presence: true

  FREQUENCY_OPTIONS = %i[total week two_weeks four_weeks monthly annually].freeze

  def frequency_options
    FREQUENCY_OPTIONS.map do |key|
      OpenStruct.new(value: key, label: I18n.t("build_estimates.employment.frequency.#{key}"))
    end
  end
end
