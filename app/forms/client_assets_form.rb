class ClientAssetsForm < AssetsForm
  include SessionPersistable
  include AddAnotherable

  delegate :smod_applicable?, to: :check

  attribute :investments_in_dispute, :boolean
  validates :investments_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?
  attribute :valuables_in_dispute, :boolean
  validates :valuables_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

  ATTRIBUTES = (BASE_ATTRIBUTES + %i[investments_in_dispute valuables_in_dispute bank_accounts]).freeze

  ITEMS_SESSION_KEY = "bank_accounts".freeze
  ITEM_MODEL = BankAccountModel
  alias_attribute :bank_accounts, :items

  class << self
    def add_extra_attributes_to_model_from_session(bank_account_model, session_data, _)
      check = Check.new(session_data)
      bank_account_model.smod_applicable = check.smod_applicable?
    end
  end
end
