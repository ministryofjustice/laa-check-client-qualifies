class DependantIncomeDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include AddAnotherable

  ITEMS_SESSION_KEY = "dependant_incomes".freeze
  ITEM_MODEL = DependantIncomeModel
  ATTRIBUTES = %i[dependant_incomes].freeze
  alias_attribute :dependant_incomes, :items

  def max_items
    (check.adult_dependants ? check.adult_dependants_count : 0) + (check.child_dependants ? check.child_dependants_count : 0)
  end
end
