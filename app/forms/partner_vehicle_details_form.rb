class PartnerVehicleDetailsForm < BaseVehicleDetailsForm
  include SessionPersistableForPartner

  ATTRIBUTES = BASE_ATTRIBUTES.freeze
end
