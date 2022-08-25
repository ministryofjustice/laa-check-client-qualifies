class MonthlyIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :monthly_incomes, array: true, default: []

  # If the 'exclusive' option is picked, then no items are sent
  # otherwise we should get at least 2 (a blank plus at least one selected)
  validates_each :monthly_incomes do |record, attr, value|
    record.errors.add(attr, I18n.t("errors.at_least_one_income")) if value.size == 1
  end

  INCOME_ATTRIBUTES = [:employment_income, :friends_or_family].freeze

  INCOME_ATTRIBUTES.each do |income_type|
    attribute income_type, :decimal
    validates income_type, numericality: {greater_than: 0}, if: -> { monthly_incomes.include?(income_type.to_s) }
  end
end
