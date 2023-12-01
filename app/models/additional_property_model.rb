class AdditionalPropertyModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  ATTRIBUTES = %i[house_value inline_owned_with_mortgage mortgage percentage_owned house_in_dispute].freeze

  delegate :partner, :property_owned, :smod_applicable?, to: :check

  attribute :house_value, :gbp
  validates :house_value, numericality: { greater_than: 0, allow_nil: true }, presence: true, is_a_number: true

  attribute :inline_owned_with_mortgage, :boolean
  validates :inline_owned_with_mortgage, inclusion: { in: [true, false] }, allow_nil: false, if: :show_inline_mortgage_ownership_question?

  attribute :mortgage, :gbp
  validates :mortgage,
            numericality: { greater_than: 0, allow_nil: true },
            is_a_number: true,
            presence: true,
            if: :owned_with_mortgage?

  attribute :percentage_owned, :fully_validatable_integer
  validates :percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true },
            is_a_number: true,
            presence: true

  attribute :house_in_dispute, :boolean
  validates :house_in_dispute, inclusion: { in: [true, false] }, allow_nil: false, if: :smod_applicable

  attr_accessor :ownership_status, :smod_applicable

  def show_inline_mortgage_ownership_question?
    ownership_status.blank?
  end

  def owned_with_mortgage?
    return inline_owned_with_mortgage if show_inline_mortgage_ownership_question?

    ownership_status == "with_mortgage"
  end
end
