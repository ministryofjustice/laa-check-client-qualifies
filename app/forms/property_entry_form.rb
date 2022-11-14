class PropertyEntryForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[house_value mortgage percentage_owned house_in_dispute].freeze

  attr_accessor :property_owned

  attribute :house_value, :gbp
  validates :house_value, numericality: { greater_than: 0, allow_nil: true }, presence: true

  attribute :mortgage, :gbp
  validates :mortgage,
            numericality: { greater_than: 0, allow_nil: true },
            presence: { if: -> { property_owned == "with_mortgage" } }

  attribute :percentage_owned, :integer
  validates :percentage_owned,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 100, allow_nil: true, message: :within_range },
            presence: true

  attribute :house_in_dispute, :boolean
  validates :house_in_dispute, inclusion: { in: [true, false] }, allow_nil: false

  def self.from_session(session_data)
    super(session_data).tap { set_property_ownership(_1, session_data) }
  end

  def self.from_params(params, session_data)
    super(params, session_data).tap { set_property_ownership(_1, session_data) }
  end

  def self.set_property_ownership(form, session_data)
    form.property_owned = session_data["property_owned"]
  end
end
