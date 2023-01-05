class PartnerDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableForPartner

  attr_accessor :passporting

  ATTRIBUTES = %i[over_60 employed].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }, if: -> { !passporting || attr != :employed }
  end

  class << self
    def from_session(session_data)
      super(session_data).tap { set_extra_properties(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_extra_properties(_1, session_data) }
    end

    def set_extra_properties(form, session_data)
      form.passporting = session_data["passporting"]
    end
  end
end
