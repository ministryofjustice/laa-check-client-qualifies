class PartnerAssetsForm < AssetsForm
  include SessionPersistableForPartner
  include AddAnotherable

  ATTRIBUTES = (BASE_ATTRIBUTES + %i[bank_accounts]).freeze

  ITEMS_SESSION_KEY = "partner_bank_accounts".freeze
  ITEM_MODEL = BankAccountModel
  alias_attribute :bank_accounts, :items
end
