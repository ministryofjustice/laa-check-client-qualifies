class HousingBenefitDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[housing_benefit_value housing_benefit_frequency].freeze

  attribute :housing_benefit_value, :gbp
  validates :housing_benefit_value, numericality: { greater_than: 0, allow_nil: true }, presence: true

  attribute :housing_benefit_frequency, :string
  validates :housing_benefit_frequency, inclusion: { in: BenefitModel::FREQUENCY_OPTIONS, allow_nil: false }

  def frequencies
    BenefitModel::FREQUENCY_OPTIONS.map { [_1, I18n.t("estimate_flow.benefits.frequencies.#{_1}")] }
  end
end
