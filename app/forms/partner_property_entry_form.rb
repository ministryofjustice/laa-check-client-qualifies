class PartnerPropertyEntryForm < BasePropertyEntryForm
  include SessionPersistableForPartner

  ATTRIBUTES = BASE_ATTRIBUTES.freeze

  class << self
    def from_session(session_data)
      super(session_data).tap { set_property_ownership(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_property_ownership(_1, session_data) }
    end

    def set_property_ownership(form, session_data)
      form.property_owned = session_data["partner_property_owned"]
    end
  end
end
