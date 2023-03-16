class ClientPropertyEntryForm < BasePropertyEntryForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[house_in_dispute joint_ownership joint_percentage_owned]).freeze

  delegate :partner, :property_owned, :smod_applicable?, to: :estimate

  attribute :house_in_dispute, :boolean
  validates :house_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable?

  attribute :joint_ownership, :boolean
  validates :joint_ownership, inclusion: { in: [true, false] }, allow_nil: false, if: -> { partner }

  attribute :joint_percentage_owned, :fully_validatable_integer
  validates :joint_percentage_owned,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100, message: :within_range },
            if: -> { joint_ownership }

  validate :total_ownership_cannot_exceed_one_hundred, if: -> { joint_ownership }

private

  def total_ownership_cannot_exceed_one_hundred
    if percentage_owned.to_i + joint_percentage_owned.to_i > 100
      errors.add(:joint_percentage_owned, :cannot_exceed_100)
    end
  end
end
