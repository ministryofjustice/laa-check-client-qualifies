class ClientPropertyEntryForm < BasePropertyEntryForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[house_in_dispute joint_ownership joint_percentage_owned]).freeze

  attr_accessor :partner

  attribute :house_in_dispute, :boolean

  attribute :joint_ownership, :boolean
  validates :joint_ownership, inclusion: { in: [true, false] }, allow_nil: false, if: -> { partner }

  attribute :joint_percentage_owned, :fully_validatable_integer
  validates :joint_percentage_owned,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100, message: :within_range },
            if: -> { joint_ownership }

  validate :total_ownership_cannot_exceed_one_hundred, if: -> { joint_ownership }

  class << self
    def from_session(session_data)
      super(session_data).tap { set_extra_properties(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_extra_properties(_1, session_data) }
    end

    def set_extra_properties(form, session_data)
      form.partner = session_data["partner"]
      form.property_owned = session_data["property_owned"]
    end
  end

private

  def total_ownership_cannot_exceed_one_hundred
    if percentage_owned.to_i + joint_percentage_owned.to_i > 100
      errors.add(:joint_percentage_owned, :cannot_exceed_100)
    end
  end
end
