class BenefitDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include AddAnotherable

  ITEMS_SESSION_KEY = "benefits".freeze
  ITEM_MODEL = BenefitModel
  ATTRIBUTES = %i[benefits].freeze
  alias_attribute :benefits, :items

  def benefit_list
    @benefit_list ||= begin
      display_list = cfe_benefit_list.reject { _1["exclude_from_gross_income"] || _1["label"].in?(PASSPORTED_BENEFITS) }
      display_list.map { _1["name"] }.uniq
    end
  end

private

  PASSPORTED_BENEFITS = %w[
    age_related_payment
    universal_credit
    income_support
    jobseekers_allowance
    employment_support_allowance
    pension_credit
  ].freeze

  def cfe_benefit_list
    CfeConnection.state_benefit_types
  end
end
