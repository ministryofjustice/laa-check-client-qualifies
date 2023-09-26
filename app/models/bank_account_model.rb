class BankAccountModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[amount
                  account_in_dispute].freeze

  attribute :amount, :gbp
  validates :amount,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true },
            is_a_number: true,
            presence: true

  attribute :account_in_dispute, :boolean
  validates :account_in_dispute, inclusion: { in: [true, false], allow_nil: false }, if: :smod_applicable

  attr_accessor :smod_applicable
end
