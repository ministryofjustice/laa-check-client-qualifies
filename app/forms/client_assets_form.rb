class ClientAssetsForm < BaseAssetsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[savings_in_dispute investments_in_dispute valuables_in_dispute]).freeze

  delegate :smod_applicable?, to: :check
  attribute :savings_in_dispute, :boolean
  validates :savings_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?
  attribute :investments_in_dispute, :boolean
  validates :investments_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?
  attribute :valuables_in_dispute, :boolean
  validates :valuables_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?
end
