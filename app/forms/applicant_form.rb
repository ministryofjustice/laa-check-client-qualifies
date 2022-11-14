class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  PERMANENT_ATTRIBUTES = %i[passporting over_60 employed].freeze
  CONTINGENT_ATTRIBUTES = %i[partner_over_60 partner_employed].freeze

  ATTRIBUTES = PERMANENT_ATTRIBUTES + CONTINGENT_ATTRIBUTES.freeze

  attr_accessor :partner

  PERMANENT_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }
  end

  CONTINGENT_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }, if: -> { partner }
  end

  def self.from_session(session_data)
    super(session_data).tap { add_partner_attribute(_1, session_data) }
  end

  def self.from_params(params, session_data)
    super(params, session_data).tap { add_partner_attribute(_1, session_data) }
  end

  def self.add_partner_attribute(form, session_data)
    form.partner = session_data["partner"]
  end
end
