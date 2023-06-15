class BaseAssetsForm < BaseAddAnotherForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include NumberValidatable

  BASE_ATTRIBUTES = %i[investments valuables].freeze

  ATTRIBUTES = (BASE_ATTRIBUTES + %i[investments_in_dispute valuables_in_dispute]).freeze

  delegate :smod_applicable?, to: :check

  attribute :investments_in_dispute, :boolean
  validates :investments_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

  attribute :valuables_in_dispute, :boolean
  validates :valuables_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

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

  class << self
    def add_session_attributes(bank_account_model, session_data)
      check = Check.new(session_data)
      bank_account_model.smod_applicable = check.smod_applicable?
    end
  end
end
