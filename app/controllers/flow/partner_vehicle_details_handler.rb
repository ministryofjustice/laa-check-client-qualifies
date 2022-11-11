module Flow
  class PartnerVehicleDetailsHandler < PartnerHandler
    # The original form class is 'BaseVehicleDetailsForm', and we want to ensure 'Base' is omitted
    def partner_form_class_name
      @partner_form_class_name ||= "PartnerVehicleDetailsForm"
    end
  end
end
