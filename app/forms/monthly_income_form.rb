class MonthlyIncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # list of checkbox values ticked on the form
  attribute :monthly_incomes, array: true, default: []

  # If the 'exclusive' option is picked, then no items are sent
  # otherwise we should get at least 2 (a blank plus at least one selected)
  validates :monthly_incomes, at_least_one_item: true

  INCOME_ATTRIBUTES = %i[employment_income friends_or_family student_finance maintenance].freeze

  INCOME_ATTRIBUTES.each do |attribute|
    attribute attribute, :decimal
    validates attribute,
              numericality: { greater_than: 0, allow_nil: true },
              presence: true,
              if: -> { monthly_incomes.include?(attribute.to_s) }
  end
end
