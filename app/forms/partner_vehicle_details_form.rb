class PartnerVehicleDetailsForm < BaseVehicleDetailsForm
  include SessionPersistableForPartner

  ATTRIBUTES = BASE_ATTRIBUTES.freeze

  def vehicle_in_dispute
    false
  end
end
