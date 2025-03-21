class IncomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include AddAnotherable

  ITEMS_SESSION_KEY = "incomes".freeze
  ITEM_MODEL = IncomeModel
  ATTRIBUTES = %i[incomes].freeze
  alias_method :incomes, :items
  alias_method :incomes=, :items=

  def self.add_extra_attributes_to_model_from_session(model, session_data, _)
    model.controlled = Steps::Logic.controlled?(session_data)
  end
end
