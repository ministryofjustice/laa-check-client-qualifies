class ClientAssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable
  include AddAnotherable

  BASE_ATTRIBUTES = %i[investments valuables].freeze

  BASE_ATTRIBUTES.each do |asset_type|
    attribute asset_type, :gbp
    validates asset_type, numericality: { greater_than_or_equal_to: 0, allow_nil: true }, presence: true
  end

  delegate :smod_applicable?, to: :check
  attribute :investments_in_dispute, :boolean
  validates :investments_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?
  attribute :valuables_in_dispute, :boolean
  validates :valuables_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

  ATTRIBUTES = (BASE_ATTRIBUTES + %i[investments_in_dispute valuables_in_dispute bank_accounts]).freeze

  ITEMS_SESSION_KEY = "bank_accounts".freeze
  ITEM_MODEL = BankAccountModel
  alias_attribute :bank_accounts, :items
  validate :positive_valuables_must_be_over_500

  class << self
    def add_extra_attributes_to_model_from_session(bank_account_model, session_data, _)
      check = Check.new(session_data)
      bank_account_model.smod_applicable = check.smod_applicable?
    end
  end

  def positive_valuables_must_be_over_500
    return if valuables.to_i <= 0 || valuables >= 500

    errors.add(:valuables, :below_500)
  end
end
