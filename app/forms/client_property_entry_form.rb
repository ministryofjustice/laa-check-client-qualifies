class ClientPropertyEntryForm < BasePropertyEntryForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[house_in_dispute]).freeze

  attr_accessor :partner

  attribute :house_in_dispute, :boolean
  validates :house_in_dispute, inclusion: { in: [true, false] }, allow_nil: false

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
end
