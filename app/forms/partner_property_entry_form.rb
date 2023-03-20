class PartnerPropertyEntryForm < BasePropertyEntryForm
  include SessionPersistableForPartner

  ATTRIBUTES = BASE_ATTRIBUTES.freeze
end
