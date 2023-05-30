class BankAccountModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include NumberValidatable

  ATTRIBUTES = %i[bank_account_value bank_account_in_dispute].freeze

  attribute :bank_account_value, :gbp
  validates :bank_account_value,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true

  attribute :bank_account_in_dispute, :boolean
  validates :bank_account_in_dispute, inclusion: { in: [true, false], allow_nil: false }, if: :smod_applicable

  attr_accessor :smod_applicable
end
