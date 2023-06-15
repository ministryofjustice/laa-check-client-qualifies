class PartnerAssetsForm < BaseAddAnotherForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include NumberValidatable

  BASE_ATTRIBUTES = %i[investments valuables].freeze

  SESSION_KEY = "savings".freeze
  ITEM_MODEL = BankAccountModel
  ADD_ANOTHER_ATTRIBUTES = %i[bank_accounts].freeze
  alias_attribute :bank_accounts, :items

  BASE_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :gbp
    validates asset_type, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true
  end

  validate :positive_valuables_must_be_over_500

  def positive_valuables_must_be_over_500
    return if valuables.to_i <= 0 || valuables >= 500

    errors.add(:valuables, :below_500)
  end
end
