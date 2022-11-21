class PartnerAssetsForm < BaseAssetsForm
  include SessionPersistableForPartner
  ATTRIBUTES = BASE_ATTRIBUTES.freeze
end
